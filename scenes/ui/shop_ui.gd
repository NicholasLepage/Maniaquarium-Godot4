extends CanvasLayer


@export var money_manager: MoneyManager

@onready var zeni_total_label = %ZeniTotalLabel
@onready var buy_fish_sfx = %BuyFishSFX
@onready var win_intro_sfx: AudioStreamPlayer = %WinIntroSFX
@onready var win_sike_sfx: AudioStreamPlayer = %WinSikeSFX

@onready var buy_fish_button = %BuyFishButton
@onready var buy_fish_cost_label = %BuyFishCostLabel

@onready var buy_mouse_fish_button = %BuyMouseFishButton
@onready var buy_mouse_fish_cost_label = %BuyMouseFishCostLabel
@onready var max_amount_label: Label = %MaxAmountLabel

@onready var buy_win_button: Button = %BuyWinButton
@onready var buy_win_egg_label: Label = %BuyWinEggLabel
@onready var win_egg_sprite: Sprite2D = %WinEggSprite
@onready var jewel_collected_particle: GPUParticles2D = %JewelCollectedParticle
@onready var mid_finga_2d: Sprite2D = %MidFinga2D
@onready var trophy_2d: Sprite2D = %Trophy2D
@onready var win_text: Label = %WinText

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var center_container_win: CenterContainer = %CenterContainerWin

# Shop Prices
var basic_fish_cost: int = 20
var mouse_fish_cost: int = 100
var win_egg_cost: int = 250

var mouse_fish_in_play: bool = false


func _ready():
	# Shop setup
	money_manager.zeni_changed.connect(_on_zeni_changed)
	buy_fish_button.pressed.connect(_on_buy_fish_button_pressed)
	Events.mouse_fish_died.connect(_on_mouse_fish_died)
	
	buy_fish_cost_label.text = str(basic_fish_cost)
	buy_mouse_fish_cost_label.text = str(mouse_fish_cost)
	buy_win_egg_label.text = str(win_egg_cost)
	
	update_zeni_label()
	update_mouse_fish_max_amount_label()
	check_disabled()

# Run this everytime the player's Zeni count changes.
func update_zeni_label():
	zeni_total_label.text = "Ƶeni: " + str(money_manager.zeni_total)

# Manages the 'Enabled' state of the Buttons.
func check_disabled():
	if money_manager.zeni_total < basic_fish_cost:
		buy_fish_button.disabled = true
	else:
		buy_fish_button.disabled = false
		
	if money_manager.zeni_total < mouse_fish_cost or mouse_fish_in_play:
		if Events.win_counter >= 1:
			return
		buy_mouse_fish_button.disabled = true
	else:
		buy_mouse_fish_button.disabled = false
	
	
	if money_manager.zeni_total < win_egg_cost:
		win_egg_sprite.modulate =  Color.hex(0xffffff32)
		buy_win_button.disabled = true
	else:
		win_egg_sprite.modulate =  Color.hex(0xffffffff)
		buy_win_button.disabled = false


# Handles mouse fish button due to its max amount.
func update_mouse_fish_max_amount_label():
	# NG+: Unlimited mouse fishies
	if Events.win_counter >= 1:
		max_amount_label.text = "?/Infinity"
		return

	if mouse_fish_in_play:
		max_amount_label.text = "1/1"
	else:
		max_amount_label.text = "0/1"


func _on_zeni_changed():
	update_zeni_label()
	check_disabled()


func _on_buy_fish_button_pressed():
	Events.basic_fish_bought.emit(basic_fish_cost)
	buy_fish_sfx.play(0.2)
	update_zeni_label()
	check_disabled()


func _on_buy_mouse_fish_button_pressed():
	mouse_fish_in_play = true 
	Events.mouse_fish_bought.emit(mouse_fish_cost)
	buy_fish_sfx.play(0.2)
	update_zeni_label()
	update_mouse_fish_max_amount_label()
	check_disabled()


func _on_mouse_fish_died(_owner):
	mouse_fish_in_play = false
	update_mouse_fish_max_amount_label()


func _on_buy_win_button_pressed() -> void:
	win_intro_sfx.play()
	buy_win_button.disabled = true
	Events.win_egg_bought.emit(win_egg_cost)
	jewel_collected_particle.emitting = true
	animation_player.play("win_egg_bought_animation")
	update_zeni_label()
	
	# NG+
	if Events.win_counter == 2:
		win_text.text = "Ayo what you doin', you already got the trophy"
	elif Events.win_counter > 2:
		var format_string = "Ayo what you doin', you already got %s trophies"
		win_text.text = format_string % str(Events.win_counter - 1)

# TODO: Remove this
func end_it_all():
	center_container_win.visible = true
	Events.new_game_plus = true

# TODO: Old end screen, remove this too
func play_troll():
	win_sike_sfx.play(0.2)
	await get_tree().create_timer(0.2).timeout
	win_intro_sfx.stop()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
