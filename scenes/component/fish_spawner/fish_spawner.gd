extends Node2D

@export var basic_fish: PackedScene
@export var mouse_fish: PackedScene

@export var foreground: Node2D


func _ready():
	Events.basic_fish_bought.connect(_on_basic_fish_bought)
	Events.mouse_fish_bought.connect(_on_mouse_fish_bought)

# Spawns basic fishes
func _on_basic_fish_bought(_cost):
	var new_fish = basic_fish.instantiate()
	foreground.add_child(new_fish)
	
	var spawn_position = position + Vector2(0, randf_range(0, -500))
	new_fish.position = spawn_position

# Spawns mouse fishes
# TODO: Refactor this if you add more fishies (spawn_purchased_fish(fish), and within: assign_position()
func _on_mouse_fish_bought(_cost: int):
	var new_mouse_fish = mouse_fish.instantiate()
	foreground.add_child(new_mouse_fish)
	
	var spawn_position = position + Vector2(640, -280)
	new_mouse_fish.position = spawn_position
