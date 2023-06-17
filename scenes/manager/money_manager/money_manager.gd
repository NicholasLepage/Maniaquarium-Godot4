extends Node
class_name MoneyManager

signal zeni_changed

@export var starting_money: int = 20
var zeni_total: int


func _ready():
	Events.basic_fish_bought.connect(_on_basic_fish_bought)
	Events.mouse_fish_bought.connect(_on_mouse_fish_bought)
	Events.win_egg_bought.connect(_on_win_egg_bought)
	
	if Events.new_game_plus:
		starting_money = 99990
		
	zeni_total = starting_money
	zeni_changed.emit()


func zeni_add(value: int):
	zeni_total += value
	zeni_changed.emit()


func zeni_remove(value: int):
	zeni_total -= value
	zeni_changed.emit()


func _on_basic_fish_bought(basic_fish_cost):
	zeni_total -= basic_fish_cost


func _on_mouse_fish_bought(mouse_fish_cost):
	zeni_total -= mouse_fish_cost


func _on_win_egg_bought(win_egg_cost):
	zeni_total -= win_egg_cost
