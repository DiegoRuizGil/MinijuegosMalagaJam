extends ColorRect
class_name FotomatonFlash

@export var hold_time := 0.5
@export var fade_time := 0.2

var _tween: Tween


func _ready() -> void:
	color.a = 0.0


func flash() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	color.a = 1.0
	_tween = create_tween()
	_tween.tween_interval(hold_time)
	_tween.tween_property(self, "color:a", 0.0, fade_time) \
		.set_ease(Tween.EASE_OUT)
