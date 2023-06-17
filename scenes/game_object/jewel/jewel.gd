extends RigidBody2D

signal jewel_spawned

@onready var jewel_collected_sfx = $JewelCollectedSFX
@onready var money_manager = get_tree().get_first_node_in_group("money_manager") as MoneyManager
@onready var jewel_collected_particle = %JewelCollectedParticle

func _ready():
	jewel_spawned.emit()


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			jewel_collected_sfx.play()
			jewel_collected_particle.emitting = true
			$Sprite2D.visible = false
			$Area2D/CollisionShape2D.disabled = true
			money_manager.zeni_add(5)


func _on_jewel_collected_sfx_finished():
	queue_free()
