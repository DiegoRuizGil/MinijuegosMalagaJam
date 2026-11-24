extends ColorRect
class_name Polaroid

@export var photo: TextureRect
@export var player_tag: ColorRect
@export var player_label: Label


func set_photo(texture: Texture2D, player_id: int) -> void:
	photo.texture = texture
	player_tag.color = _get_player_color(player_id)
	player_label.text = "PLAYER " + str(player_id + 1)


func _get_player_color(player_id: int) -> Color:
	if player_id == 0:
		return Color("#D04856")
	if player_id == 1:
		return Color("#2867BF")
	if player_id == 2:
		return Color("#53A74C")
	if player_id == 3:
		return Color("#ACA846")
	return Color(0,0,0)
