extends CharacterBody2D

@export var MAX_SPEED: float = 100

@onready var hunger_component = $HungerComponent
@onready var mouth_area_2d = %MouthArea2D
@onready var debug_label = $DebugLabel
@onready var pellet_eaten_sfx = $PelletEatenSFX
@onready var velocity_component = $VelocityComponent
@onready var money_drop_component: Node = $MoneyDropComponent
@onready var sprite_2d = $Visuals/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var movement_direction: Vector2 = Vector2(1, 0)


func _ready():
	# Note: Future projects: connect signals through GUI for cleaner code
	Events.fish_died.connect(_on_fish_died)
	Events.mouth_touched_fish_turner.connect(_on_mouth_touched_fish_turner)
	hunger_component.hunger_changed.connect(_on_hunger_changed)
	mouth_area_2d.fish_ate.connect(_on_fish_ate)

	# NG+ Behavior
	if Events.new_game_plus:
		hunger_component.max_hunger_level = 999


func _physics_process(_delta: float) -> void:
	velocity_component.accelerate_in_direction(movement_direction)
	velocity_component.move(self)


func _on_fish_ate():
	pellet_eaten_sfx.play()


func _on_fish_died(fish):
	if fish == self:
		animation_player.play("dying")

# Basic fish navigation + Sprite correction
func _on_mouth_touched_fish_turner(fish):
	if fish == self:
		sprite_2d.scale.x = -sprite_2d.scale.x
		movement_direction = -movement_direction

# Debug feature
func _on_hunger_changed(hunger_level):
	debug_label.text = str(hunger_level)
