extends Node

@export var jewel_scene: PackedScene
@export var timer_value = 3

@onready var money_drop_timer = $MoneyDropTimer


func _ready():
	pick_timer_value()


func set_drop_timer_value(new_timer_value):
	money_drop_timer.start(new_timer_value)


func _on_money_drop_timer_timeout():
	var jewel = jewel_scene.instantiate() as RigidBody2D
	var foreground = get_tree().get_first_node_in_group("foreground")
	foreground.add_child(jewel)
	jewel.position = owner.position
	
	pick_timer_value()


func pick_timer_value():
	var value = randi() % 3 # Pick a random integer between 0 and 2
	match value:
		0:
			money_drop_timer.start(timer_value-1)
		1:
			money_drop_timer.start(timer_value)
		2:
			money_drop_timer.start(timer_value+1)
