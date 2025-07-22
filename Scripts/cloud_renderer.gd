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
