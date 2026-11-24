extends Node
class_name PosesManager

@export var current_pose_timer: Timer
## weight / (weight + N - 1)
@export_range(1.0, 20.0, 0.1) var target_pose_weight := 3.0
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
	var candidates := poses_array.filter(func(p: PoseInfo): return p != _target_pose)
	if candidates.is_empty():
		candidates = poses_array
	_target_pose = candidates[_rng.randi_range(0, candidates.size() - 1)]
	target_pose_label.text = _target_pose.name
	target_pose_image.texture = _target_pose.sketch


func _change_current_pose() -> void:
	var weights := PackedFloat32Array()
	for pose in poses_array:
		weights.append(target_pose_weight if pose == _target_pose else 1.0)
	_current_pose = poses_array[_rng.rand_weighted(weights)]
	character.set_pose(_current_pose)
