extends Control
class_name CameraLens

@export_category("Audio")
@export var audio_manager: FotomatonAudioManager

@export_category("Tween")
@export var shoot_scale: float = 0.85
@export var shoot_duration: float = 0.15

@export_category("Colors")
@export var turn_on_color: Color
@export var turn_off_color: Color

var _tween: Tween

const TAKE_PHOTO_SFX := preload("res://Minigames/FotomatonMinigame/Audio/SFX/take_photo.WAV")


func take_photo() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	
	audio_manager.play_sfx(TAKE_PHOTO_SFX, 0.0, 0.05)
	_tween = create_tween()
	_tween.tween_property(self, "scale", Vector2.ONE * shoot_scale, shoot_duration) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "scale", Vector2.ONE, shoot_duration)
	_tween.tween_callback(turn_off)


func turn_on() -> void: _set_color(turn_on_color)


func turn_off() -> void: _set_color(turn_off_color)


func _set_color(color: Color) -> void:
	for rect in find_children("*", "ColorRect", true, false):
		rect.color = color
