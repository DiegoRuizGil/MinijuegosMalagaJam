extends MinigameBase

@export var minigame_timer: Timer
@export var player_points: FotoMatonPoints
@export var battery: Battery
@export var camera_lens: CameraLens
@export var photo_viewport: FotomatonPhotoViewport
@export var poses_manager: PosesManager
@export var print_slot: PrintSlot
@export var canvas_layer: CanvasLayer


func _ready() -> void:
	battery.charged.connect(func(): camera_lens.turn_on())
	canvas_layer.visible = false


func OnMinigameStarted() -> void:
	poses_manager.start()
	canvas_layer.visible = true


func OnPlayerPressed(playerId: int) -> void:
	if battery.is_charged():
		battery.recharge()
		camera_lens.take_photo()
		if poses_manager.is_desired_pose():
			_score_point(playerId)


func game_ended() -> void:
	var winners: Array[int] = player_points.get_winners_id()
	for id in winners:
		ScoreManager.AddVictoryToPlayer(id)
	
	StopMinigame()
	await get_tree().create_timer(1).timeout
	TransitionToNextMinigame()


func _score_point(player_id: int) -> void:
	var photo := await photo_viewport.capture()
	print_slot.print_photo(photo, player_id)
	player_points.add_point(player_id)
	poses_manager.select_next_target_pose()
