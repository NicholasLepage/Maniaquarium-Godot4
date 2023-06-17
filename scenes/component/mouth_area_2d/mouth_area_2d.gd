extends Area2D

signal fish_ate


func _on_area_entered(area):
	if area.is_in_group("pellet"):
		fish_ate.emit()
		Events.pellet_despawned.emit()
		area.get_parent().queue_free()
