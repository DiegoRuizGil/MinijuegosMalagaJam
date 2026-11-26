extends Control
class_name Battery

@export var cooldown_timer: Timer
@export var empty_color := Color(0.35, 0.35, 0.35)
@export var jump_height := 20.0
@export var jump_up_time := 0.1

@export_category("Audio")
@export var audio_manager: FotomatonAudioManager

@export_category("Sprites")
@export var sprites: Array[TextureRect]

signal charged

var _jump_tweens: Array[Tween] = []

const BATTERY_SFX := preload("res://Minigames/FotomatonMinigame/Audio/SFX/battery_0.WAV")


func _ready() -> void:
	set_process(false)
	cooldown_timer.timeout.connect(_on_cooldown_finished)
	

func _process(_delta: float) -> void:
	var progress := 1.0 - cooldown_timer.time_left / cooldown_timer.wait_time
	var filled := progress * sprites.size()
	for i in sprites.size():
		var t := clampf(filled - i, 0.0, 1.0)
		#sprites[i].modulate = empty_color.lerp(Color.WHITE, t)
		sprites[i].modulate = Color.WHITE if t > 0 else empty_color


func recharge() -> void:
	_stop_jumps()
	set_process(true)
	cooldown_timer.start()


func is_charged() -> bool: return cooldown_timer.is_stopped()


func _on_cooldown_finished() -> void:
	set_process(true)
	for sprite in sprites:
		sprite.modulate = Color.WHITE
	_play_ready_wave()
	audio_manager.play_sfx(BATTERY_SFX)
	charged.emit()


func _play_ready_wave() -> void:
	_stop_jumps()
	for i in sprites.size():
		var sprite := sprites[i]
		var tween := create_tween()
		
		tween.tween_interval(i * jump_up_time)
		tween.tween_property(sprite, "position:y", -jump_height, jump_up_time) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite, "position:y", 0.0, jump_up_time) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		_jump_tweens.append(tween)


func _stop_jumps() -> void:
	for tween in _jump_tweens:
		if tween.is_valid():
			tween.kill()
	_jump_tweens.clear()
	for sprite in sprites:
		sprite.position.y = 0.0
