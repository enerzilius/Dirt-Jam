@tool
class_name DrawVolumetricCloudMesh extends CompositorEffect

@export_group("Visual Settings")
@export var cloud_density: float = 1.0
@export var coverage: float = 0.2

var rd : RenderingDevice

var transform : Transform3D
var light : DirectionalLight3D
var cam : Camera3D

func _init():
	effect_callback_type = CompositorEffect.EFFECT_CALLBACK_TYPE_POST_TRANSPARENT
	
	rd = RenderingServer.get_rendering_device()

	# Gets whatever light source is in the scene, compositor effects are resources not nodes and so we need to do some jank stuff to get access to the node scene tree
	var tree := Engine.get_main_loop() as SceneTree
	var root : Node = tree.edited_scene_root if Engine.is_editor_hint() else tree.current_scene
	if root: light = root.get_node_or_null('DirectionalLight3D')
	
func initialize_render(framebuffer_format : int):
	var source_vertex: String = read_file("res://Scripts/Shaders/Vertex.txt")
	var source_fragment: String = read_file("res://Scripts/Shaders/Fragment.txt")
	var source_wire_fragment: String = read_file("res://Scripts/Shaders/WireFragment.txt")
	p_shader = compile_shader(source_vertex, source_fragment)
	p_wire_shader = compile_shader(source_vertex, source_wire_fragment)

	var vertex_buffer := PackedFloat32Array([])
	var half_length = (side_length - 1) / 2.0

	# Generate plane vertices on the xz plane
	for x in side_length:
		for z in side_length:
			# LOD vai ser feito aqui!!
			var xz : Vector2 = Vector2(x - half_length, z - half_length) * mesh_scale
			
			var pos : Vector3 = Vector3(xz.x, 0, xz.y)

			# Vertex color is not used but left as a demonstration for adding more vertex attributes
			var color : Vector4 = Vector4(randf(), randf(), randf(), 1)
			
			# For some reason godot doesn't make it easy to append vectors to arrays
			for i in 3: vertex_buffer.push_back(pos[i])
			for i in 4: vertex_buffer.push_back(color[i])


	var vertex_count = vertex_buffer.size() / 7
	print("Vertex Count: " + str(vertex_count))

	# Dump vertex data, I would delete this but it's probably helpful definitely do not uncomment this if your mesh has more than a couple vertices
	# for i in vertex_count:
	#     var j = i * 7
	#     var pos = Vector3()

	#     pos.x = vertex_buffer[j]
	#     pos.y = vertex_buffer[j + 1]
	#     pos.z = vertex_buffer[j + 2]

	#     var color = Vector4()

	#     color.x = vertex_buffer[j + 3]
	#     color.y = vertex_buffer[j + 4]
	#     color.z = vertex_buffer[j + 5]
	#     color.w = vertex_buffer[j + 6]

	#     print("Vertex " + str(i) + " ---")
	#     print("Position: " + str(pos))
	#     print("Color: " + str(color))



	var index_buffer := PackedInt32Array([])
	var wire_index_buffer := PackedInt32Array([])

	# Appends vertex indices to the index buffer for triangle list and wireframe
	for row in range(0, side_length * side_length - side_length, side_length):
		for i in side_length - 1:
			var v = i + row # shift to row we're actively triangulating

			var v0 = v
			var v1 = v + side_length
			var v2 = v + side_length + 1
			var v3 = v + 1

			index_buffer.append_array([v0, v1, v3, v1, v2, v3])
			wire_index_buffer.append_array([v0, v1, v0, v3, v1, v3, v1, v2, v2, v3])

	print("Triangle Count: " + str(index_buffer.size() / 3))

	
	var vertex_buffer_bytes : PackedByteArray = vertex_buffer.to_byte_array()
	p_vertex_buffer = rd.vertex_buffer_create(vertex_buffer_bytes.size(), vertex_buffer_bytes)
	
	var vertex_buffers := [p_vertex_buffer, p_vertex_buffer]
	
	var sizeof_float := 4
	var stride := 7
	
	# The GPU needs to know the memory layout of the vertex data, in this case each vertex has a position (3 component vector) and a color (4 component vector)
	var vertex_attrs = [RDVertexAttribute.new(), RDVertexAttribute.new()]
	vertex_attrs[0].format = rd.DATA_FORMAT_R32G32B32_SFLOAT
	vertex_attrs[0].location = 0
	vertex_attrs[0].offset = 0
	vertex_attrs[0].stride = stride * sizeof_float

	vertex_attrs[1].format = rd.DATA_FORMAT_R32G32B32A32_SFLOAT
	vertex_attrs[1].location = 1
	vertex_attrs[1].offset = 3 * sizeof_float
	vertex_attrs[1].stride = stride * sizeof_float

	vertex_format = rd.vertex_format_create(vertex_attrs)


	p_vertex_array = rd.vertex_array_create(vertex_buffer.size() / stride, vertex_format, vertex_buffers)

	var index_buffer_bytes : PackedByteArray = index_buffer.to_byte_array()
	p_index_buffer = rd.index_buffer_create(index_buffer.size(), rd.INDEX_BUFFER_FORMAT_UINT32, index_buffer_bytes)
	
	var wire_index_buffer_bytes : PackedByteArray = wire_index_buffer.to_byte_array()
	p_wire_index_buffer = rd.index_buffer_create(wire_index_buffer.size(), rd.INDEX_BUFFER_FORMAT_UINT32, wire_index_buffer_bytes)

	p_index_array = rd.index_array_create(p_index_buffer, 0, index_buffer.size())
	p_wire_index_array = rd.index_array_create(p_wire_index_buffer, 0, wire_index_buffer.size())

	initialize_render_pipelines(framebuffer_format)
