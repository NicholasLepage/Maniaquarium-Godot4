extends Area2D


func _on_area_entered(area):
	if area.is_in_group("mouse_mouth"):
		return
	
	if area.is_in_group("mouth"):
		Events.mouth_touched_fish_turner.emit(area.owner)
