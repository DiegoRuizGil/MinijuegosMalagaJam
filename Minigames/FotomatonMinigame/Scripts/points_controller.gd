extends VBoxContainer
class_name PointsController

@export var players_labels: Array[Label]

signal on_player_won(player_id: int)

var players_points: Array[int] = [0,0,0,0]
const max_points: int = 10

func _ready() -> void:
	for i in range(4):
		_update_label(i)
	
	for id in PlayersController.GetCurrentPlayersIds():
		print("Player id: " + str(id))


func add_point(player_id: int) -> void:
	players_points[player_id] += 1
	_update_label(player_id)
	
	if players_points[player_id] >= max_points:
		print("El jugador " + str(player_id+1) + " ha ganado")
		on_player_won.emit(player_id)


func get_winners_id() -> Array[int]:
	var winners: Array[int]
	var max_value: int = players_points.max()
	
	for id in players_points.size():
		if players_points[id] >= max_value:
			winners.append(id)
	
	return winners


func _update_label(player_id: int) -> void:
	var label = players_labels[player_id]
	label.text = "P" + str(player_id+1) + ": " + str(players_points[player_id])
