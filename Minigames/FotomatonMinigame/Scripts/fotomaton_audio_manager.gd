extends Node
class_name FotomatonAudioManager

const SFX_POOL_SIZE := 8
const MUSIC_BUS := &"Music"
const SFX_BUS := &"SFX"

var _music: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _next_sfx := 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_music = AudioStreamPlayer.new()
	_music.bus = MUSIC_BUS
	add_child(_music)
	for i in SFX_POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.bus = SFX_BUS
		add_child(p)
		_sfx_pool.append(p)


# --- MUSIC ---
func play_music(stream: AudioStream, fade_in := 0.5) -> void:
	if _music.stream == stream and _music.playing:
		return
	_music.stream = stream
	_music.volume_db = -40.0
	_music.play()
	create_tween().tween_property(_music, "volume_db", 0.0, fade_in)


func stop_music(fade_out := 0.5) -> void:
	var t := create_tween()
	t.tween_property(_music, "volume_db", -40.0, fade_out)
	t.tween_callback(_music.stop)


# --- SFX ---
func play_sfx(stream: AudioStream, volume_db := 0.0, pitch_variation := 0.0) -> void:
	var p := _get_free_player()
	p.stream = stream
	p.volume_db = volume_db
	p.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
	p.play()


func _get_free_player() -> AudioStreamPlayer:
	for p in _sfx_pool:
		if not p.playing:
			return p
	
	var p := _sfx_pool[_next_sfx]
	_next_sfx = (_next_sfx + 1) % SFX_POOL_SIZE
	return p


func set_bus_volume(bus: StringName, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(idx, linear_to_db(linear))
	AudioServer.set_bus_mute(idx, linear <= 0.001)


func get_bus_volume(bus: StringName) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus)))
