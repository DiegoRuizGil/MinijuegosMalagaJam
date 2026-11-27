extends SubViewport
class_name FotomatonPhotoViewport

@export var main_camera: Camera3D
@export var lens: Control
@export var photo_camera: Camera3D


func _ready() -> void:
	render_target_update_mode = SubViewport.UPDATE_DISABLED
	_sync_with_lens()


func capture() -> Texture2D:
	render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	return ImageTexture.create_from_image(get_texture().get_image())


func _sync_with_lens() -> void:
	size = Vector2i(lens.size)
	
	photo_camera.global_transform = main_camera.global_transform
	photo_camera.near = main_camera.near
	photo_camera.far = main_camera.far
	photo_camera.cull_mask = main_camera.cull_mask
	
	var screen_h := main_camera.get_viewport().get_visible_rect().size.y
	var ratio := lens.size.y / screen_h
	var half_fov := deg_to_rad(main_camera.fov) * 0.5
	photo_camera.fov = rad_to_deg(2.0 * atan(tan(half_fov) * ratio))
