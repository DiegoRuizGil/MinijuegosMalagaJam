extends MinigameBase

@export var points_controller: PointsController

@export_category("Timers")
@export var minigame_timer: Timer
@export var current_pose_timer: Timer
@export var cooldown_timer: Timer

@export_category("Poses")
@export var poses_array: Array[PoseInfo]

@export_category("Info Panel")
@export var target_pose_label: Label
@export var current_pose_label: Label
@export var scored_point_label: Label
@export var batery_bar: ProgressBar

var _target_pose: PoseInfo
var _current_pose: PoseInfo

var _charging_batery: bool

var _rng = RandomNumberGenerator.new()


func _process(_delta: float) -> void:
	batery_bar.value = 1 - (cooldown_timer.time_left / cooldown_timer.wait_time)


func OnMinigameStarted() -> void:
	current_pose_timer.timeout.connect(_change_current_pose)
	current_pose_timer.start()
	
	cooldown_timer.timeout.connect(func(): _charging_batery = false)
	_charging_batery = false
	
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


func _can_shoot() -> bool:
	return !_charging_batery


func _set_cooldown() -> void:
	cooldown_timer.start()
	_charging_batery = true


func _score_point(player_id: int) -> void:
	print("[FM] Point for player " + str(player_id))
	points_controller.add_point(player_id)
	scored_point_label.text = "Point for player: " + str(player_id)
	_select_next_target_pose()


func _select_next_target_pose() -> void:
	_target_pose = _get_random()
	target_pose_label.text = "Target pose: " + _target_pose.name


func _change_current_pose() -> void:
	_current_pose = _get_random()
	current_pose_label.text = "Current pose: " + _current_pose.name
	print("[FM] Change current pose to: " + _target_pose.name)


func _get_random() -> PoseInfo:
	return poses_array[_rng.randi_range(0, poses_array.size() - 1)]
