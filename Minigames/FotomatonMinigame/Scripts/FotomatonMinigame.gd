extends MinigameBase

@export var points_controller: PointsController

@export_category("Timers")
@export var minigame_timer: Timer
@export var current_pose_timer: Timer

@export_category("Battery")
@export var battery: Battery

@export_category("Camera")
@export var camera_lens: CameraLens

@export_category("Poses")
@export var poses_array: Array[PoseInfo]

@export_category("Target Pose UI")
@export var target_pose_image: TextureRect
@export var target_pose_label: Label

@export_category("Current Pose UI")
@export var current_pose_image: TextureRect
@export var current_pose_label: Label

var _target_pose: PoseInfo
var _current_pose: PoseInfo

var _rng = RandomNumberGenerator.new()


func OnMinigameStarted() -> void:
	current_pose_timer.timeout.connect(_change_current_pose)
	current_pose_timer.start()
	
	battery.charged.connect(func(): camera_lens.turn_on())
	
	_select_next_target_pose()
	_change_current_pose()


func OnPlayerPressed(playerId: int) -> void:
	if _can_shoot():
		_set_cooldown()
		if _current_pose.name == _target_pose.name:
			_score_point(playerId)


func game_ended() -> void:
	var winners: Array[int] = points_controller.get_winners_id()
	for id in winners:
		ScoreManager.AddVictoryToPlayer(id)
	
	StopMinigame()
	await get_tree().create_timer(1).timeout
	TransitionToNextMinigame()


func _can_shoot() -> bool: return battery.is_charged()


func _set_cooldown() -> void:
	battery.recharge()
	camera_lens.take_photo()


func _score_point(player_id: int) -> void:
	points_controller.add_point(player_id)
	_select_next_target_pose()


func _select_next_target_pose() -> void:
	_target_pose = _get_random()
	target_pose_label.text = _target_pose.name
	target_pose_image.texture = _target_pose.sketch


func _change_current_pose() -> void:
	_current_pose = _get_random()
	current_pose_label.text = _current_pose.name
	current_pose_image.texture = _current_pose.sketch


func _get_random() -> PoseInfo:
	return poses_array[_rng.randi_range(0, poses_array.size() - 1)]
