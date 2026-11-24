extends Control
class_name PrintSlot

@export var polaroid: Polaroid
@export var debug_photo: Texture2D

var _hidden_pos: Vector2


func _ready() -> void:
	_hidden_pos = polaroid.position


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_C:
			print_photo(debug_photo, 0)


func print_photo(texture: Texture2D, player_id: int) -> void:
	polaroid.set_photo(texture, player_id)
	polaroid.modulate = Color(0.2, 0.2, 0.2)
	polaroid.position = _hidden_pos
	
	var tween := create_tween()
	tween.tween_property(polaroid, "position:y", 0.0, 1.4) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(polaroid, "modulate", Color.WHITE, 1.0)
