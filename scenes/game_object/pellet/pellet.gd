extends RigidBody2D


@onready var sprite_2d = $Sprite2D
@onready var eat_me_collision_shape_2d = $EatMeArea2D/EatMeCollisionShape2D


func _ready():
	Events.pellet_spawned.emit()
