extends Node
class_name FotomatonCharacter

@export var anim: AnimationPlayer


func set_pose(pose: PoseInfo) -> void:
	anim.play(pose.name)
