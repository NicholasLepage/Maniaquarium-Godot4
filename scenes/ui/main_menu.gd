extends Control

@export var menu_trophy_2d: PackedScene
@export var first_trophy_position: Vector2 = Vector2(40,54)

@onready var sprite_plus_2d: Sprite2D = %SpritePlus2D
@onready var trophy_box_container: HBoxContainer = %TrophyBoxContainer

var last_trophy_position: Vector2


func _ready():
	# NG+ modifications to Main Menu
	if Events.new_game_plus == true:
		sprite_plus_2d.visible = true
		
		var first_trophy_instance = menu_trophy_2d.instantiate()
		trophy_box_container.add_child(first_trophy_instance)
		first_trophy_instance.position = first_trophy_position
		last_trophy_position = first_trophy_position
		
		for i in Events.win_counter - 1:
			var trophy_instance = menu_trophy_2d.instantiate()
			trophy_box_container.add_child(trophy_instance)
			trophy_instance.position = last_trophy_position + Vector2(72,0)
			last_trophy_position = trophy_instance.position


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
