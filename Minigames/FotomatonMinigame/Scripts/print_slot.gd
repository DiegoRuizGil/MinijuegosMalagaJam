extends Control
class_name PrintSlot

@export var polaroid: Polaroid
@export var debug_photo: Texture2D

@export_category("Tween")
@export var show_time := 1.0
@export var reveal_time := 1.0
@export var vertical_pos := 0.0
@export var wait_before_disappearing := 1.0
@export var disappear_time := 1.0

var _hidden_pos: Vector2
var _tween: Tween


func _ready() -> void:
	_hidden_pos = polaroid.position


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_C:
			print_photo(debug_photo, 0)


func print_photo(texture: Texture2D, player_id: int) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	
	polaroid.set_photo(texture, player_id)
	polaroid.modulate = Color(0.2, 0.2, 0.2)
	polaroid.position = _hidden_pos
	polaroid.modulate.a = 1.0
	
	_tween = create_tween()
	_tween.tween_property(polaroid, "position:y", vertical_pos, show_time) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(polaroid, "modulate", Color.WHITE, reveal_time)
	_tween.tween_interval(wait_before_disappearing)
	_tween.tween_property(polaroid, "modulate:a", 0.0, disappear_time)
