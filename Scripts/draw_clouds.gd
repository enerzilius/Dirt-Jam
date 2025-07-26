#@tool
#class_name DrawVolumetricCloudMesh extends CompositorEffect
#
#@export_group("Visual Settings")
#@export var cloud_density: float = 1.0
#@export var coverage: float = 0.2
#
#var rd : RenderingDevice
#
#var transform : Transform3D
#var light : DirectionalLight3D
#var cam : Camera3D
#
#var common: Common = Common.new()
#
#func _init():
	#effect_callback_type = CompositorEffect.EFFECT_CALLBACK_TYPE_POST_TRANSPARENT
	#
	#rd = RenderingServer.get_rendering_device()
#
	## Gets whatever light source is in the scene, compositor effects are resources not nodes and so we need to do some jank stuff to get access to the node scene tree
	#var tree := Engine.get_main_loop() as SceneTree
	#var root : Node = tree.edited_scene_root if Engine.is_editor_hint() else tree.current_scene
	#if root: light = root.get_node_or_null('DirectionalLight3D')
	#
#func initialize_render(framebuffer_format : int):
	#var source_vertex: String = common.read_file("res://Scripts/Shaders/Vertex.txt")
	#var source_fragment: String = common.read_file("res://Scripts/Shaders/Fragment.txt")
	#p_shader = compile_shader(source_vertex, source_fragment)
#
	#var vertex_buffer := PackedFloat32Array([])
#
	## Generate plane vertices on the xz plane
	#var vertices = [
		#8.0, 110.0, 44.0,
		#8.0, 115.0, 44.0,
		#8.0, 110.0, 46.0,
		#8.0, 115.0, 46.0,
		#16.0, 110.0, 44.0,
		#16.0, 110.0, 46.0,
		#16.0, 115.0, 44.0,
		#16.0, 115.0, 46.0,
	#]
	#for i in len(vertices): vertex_buffer.push_back(vertices[i])
#
#
	#var vertex_count = vertex_buffer.size() / 7
	#print("Vertex Count: " + str(vertex_count))
#
	#var index_buffer := PackedInt32Array([])
#
	## Appends vertex indices to the index buffer for triangle list and wireframe
	#
#
	#print("Triangle Count: " + str(index_buffer.size() / 3))
#
	#
	#var vertex_buffer_bytes : PackedByteArray = vertex_buffer.to_byte_array()
	#p_vertex_buffer = rd.vertex_buffer_create(vertex_buffer_bytes.size(), vertex_buffer_bytes)
	#
	#var vertex_buffers := [p_vertex_buffer, p_vertex_buffer]
	#
	#var sizeof_float := 4
	#var stride := 7
	#
	## The GPU needs to know the memory layout of the vertex data, in this case each vertex has a position (3 component vector) and a color (4 component vector)
	#var vertex_attrs = [RDVertexAttribute.new(), RDVertexAttribute.new()]
	#vertex_attrs[0].format = rd.DATA_FORMAT_R32G32B32_SFLOAT
	#vertex_attrs[0].location = 0
	#vertex_attrs[0].offset = 0
	#vertex_attrs[0].stride = stride * sizeof_float
#
	#vertex_attrs[1].format = rd.DATA_FORMAT_R32G32B32A32_SFLOAT
	#vertex_attrs[1].location = 1
	#vertex_attrs[1].offset = 3 * sizeof_float
	#vertex_attrs[1].stride = stride * sizeof_float
#
	#vertex_format = rd.vertex_format_create(vertex_attrs)
#
#
	#p_vertex_array = rd.vertex_array_create(vertex_buffer.size() / stride, vertex_format, vertex_buffers)
#
	#var index_buffer_bytes : PackedByteArray = index_buffer.to_byte_array()
	#p_index_buffer = rd.index_buffer_create(index_buffer.size(), rd.INDEX_BUFFER_FORMAT_UINT32, index_buffer_bytes)
	#
#
	#p_index_array = rd.index_array_create(p_index_buffer, 0, index_buffer.size())
#
	#initialize_render_pipelines(framebuffer_format)
