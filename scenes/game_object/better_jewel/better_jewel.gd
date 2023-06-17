extends RigidBody2D

signal better_jewel_spawned

@onready var better_jewel_collected_sfx: AudioStreamPlayer2D = %BetterJewelCollectedSFX
@onready var money_manager = get_tree().get_first_node_in_group("money_manager") as MoneyManager
@onready var jewel_collected_particle = %JewelCollectedParticle

func _ready():
	better_jewel_spawned.emit()


func _on_better_jewel_collected_sfx_finished() -> void:
	queue_free()


func _on_area_2d_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			better_jewel_collected_sfx.play()
			jewel_collected_particle.emitting = true
			$Sprite2D.visible = false
			$Area2D2/CollisionShape2D.disabled = true
			money_manager.zeni_add(10)
