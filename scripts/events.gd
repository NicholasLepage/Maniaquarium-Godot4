extends Node

var new_game_plus: bool = false
var win_counter: int = 0

# Global signals that need to be accessed between disconnected components
signal basic_fish_bought(cost: int)
signal mouse_fish_bought(cost: int)
signal win_egg_bought(cost: int)
signal fish_died(fish)
signal mouse_fish_died(mouse_fish)

signal pellet_spawned
signal pellet_despawned

signal mouth_touched_fish_turner(fish)


func _ready():
	win_egg_bought.connect(_on_win_egg_bought)

# Gets called as soon as player buys the final egg.
func _on_win_egg_bought(_win_egg_cost):
	new_game_plus = true
	win_counter += 1
