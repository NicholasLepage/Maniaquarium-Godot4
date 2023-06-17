extends CharacterBody2D

@export var MAX_SPEED: float = 150

signal mouse_fish_flipped

@onready var hunger_component = $HungerComponent
@onready var mouth_area_2d = %MouthArea2D
@onready var debug_label = $DebugLabel
@onready var pellet_eaten_sfx = $PelletEatenSFX
@onready var velocity_component = $VelocityComponent
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D

var destination : Vector2
@export var rotation_speed: float = 5
var flipped: bool = false


func _ready():
	position = Vector2(640,360)
	mouse_fish_flipped.connect(_on_mouse_fish_flipped)
	Events.mouse_fish_died.connect(_on_mouse_fish_died)
	hunger_component.hunger_changed.connect(_on_hunger_changed)
	mouth_area_2d.fish_ate.connect(_on_fish_ate)


func _physics_process(delta: float) -> void:
	var target = get_global_mouse_position() - Vector2(50,0)
#	look_at(target)
	rotateToTarget(get_global_mouse_position(), delta)
	
	velocity = position.direction_to(target) * MAX_SPEED
	
	var rotation_degree = rad_to_deg(rotation)
	if rotation_degree >= 90 or rotation_degree <= -90:
		flip_self_v()
	else: 
		flipped = false
		sprite_2d.flip_v = false
		

	
	if position.distance_to(target) > 10:
		move_and_slide()


func rotateToTarget(target: Vector2, delta):
	var direction = (target - global_position)
	var angleTo = transform.x.angle_to(direction)
	rotate(sign(angleTo) * min(delta * rotation_speed, abs(angleTo)))


func flip_self_v():
	if flipped:
		return
	sprite_2d.flip_v = true



func _on_hunger_changed(hunger_level):
	debug_label.text = str(hunger_level)


func _on_mouse_fish_flipped():
	flip_self_v()


func _on_fish_ate():
	pellet_eaten_sfx.play()


func _on_mouse_fish_died(mouse_fish):
	if mouse_fish == self:
		queue_free()
