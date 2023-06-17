extends Area2D


func _on_area_entered(area):
	if area.is_in_group("pellet"):
		area.get_parent().queue_free()
		Events.pellet_despawned.emit()
