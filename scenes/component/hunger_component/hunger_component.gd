extends Node

signal hunger_changed(hunger_level: int)

@onready var hunger_timer = $HungerTimer

# Need to assign on parent, in the Editor
@export var mouth_area_2d: Area2D 
@export var hunger_timer_time: int = 3

@export var max_hunger_level: int = 5
var hunger_level: int = 1
var sprite



func _ready():
	mouth_area_2d.fish_ate.connect(_on_fish_ate)
	sprite = get_parent().get_node_or_null("Visuals/Sprite2D")
	reset_hunger_to_one(hunger_timer_time)


func reset_hunger_to_one(time: int):
	hunger_level = 1
	hunger_timer.start(time)


func check_hunger_tween():
	# Makes the parent's sprite green when he is 2 hunger ticks away from death
	if hunger_level == max_hunger_level - 2:
		if !sprite:
			return
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(0,1,0), 0.8)
	elif hunger_level < max_hunger_level - 2:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color(1,1,1), 0.3)
	


func _on_hunger_timer_timeout():
	hunger_level = hunger_level + 1
	hunger_changed.emit(hunger_level)
	
	check_hunger_tween()

	if hunger_level >= max_hunger_level:
		if owner.is_in_group("basic_fish"):
			Events.fish_died.emit(owner)
		if owner.is_in_group("mouse_fish"):
			Events.mouse_fish_died.emit(owner)


func _on_fish_ate():
	reset_hunger_to_one(hunger_timer_time)
	check_hunger_tween()
	hunger_changed.emit(hunger_level)
