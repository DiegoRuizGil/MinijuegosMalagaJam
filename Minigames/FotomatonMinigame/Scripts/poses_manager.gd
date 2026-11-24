extends Node
class_name PosesManager

@export var current_pose_timer: Timer
@export var poses_array: Array[PoseInfo]

@export_category("Character")
@export var character: FotomatonCharacter

@export_category("UI")
@export var target_pose_image: TextureRect
@export var target_pose_label: Label

var _target_pose: PoseInfo
var _current_pose: PoseInfo

var _rng = RandomNumberGenerator.new()


func start() -> void:
	current_pose_timer.timeout.connect(_change_current_pose)
	current_pose_timer.start()
	
	select_next_target_pose()
	_change_current_pose()


func is_desired_pose() -> bool: return _current_pose.name == _target_pose.name


func select_next_target_pose() -> void:
	_target_pose = _get_random()
	target_pose_label.text = _target_pose.name
	target_pose_image.texture = _target_pose.sketch


func _change_current_pose() -> void:
	_current_pose = _get_random()
	character.set_pose(_current_pose)


func _get_random() -> PoseInfo:
	return poses_array[_rng.randi_range(0, poses_array.size() - 1)]
