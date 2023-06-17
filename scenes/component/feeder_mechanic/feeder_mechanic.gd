extends Area2D

@export var basic_pellet: PackedScene

@onready var feeding_timer = %FeedingTimer
@onready var pellet_drop_sfx = $PelletDropSFX
@onready var debug_label = $DebugLabel
@onready var feeding_cd_bar = %FeedingCDBar


@export var max_pellets: int = 6
var pellets_on_screen: int = 0

var at_pellet_capacity: bool = false
var can_feed: bool = true
var foreground

func _ready():
	Events.pellet_spawned.connect(_on_pellet_spawned)
	Events.pellet_despawned.connect(_on_pellet_despawned)
	
	foreground = get_tree().get_first_node_in_group("foreground")


func _process(_delta):
	position = get_global_mouse_position()
	
	feeding_cd_bar.value = feeding_timer.time_left
	debug_label.text = str(pellets_on_screen)


func drop_pellet()->void:
	if can_feed == true and !at_pellet_capacity:
		can_feed = false
		feeding_timer.start()
		pellet_drop_sfx.play()
		
		var new_pellet = basic_pellet.instantiate()
		foreground.add_child(new_pellet)
		new_pellet.position = get_global_mouse_position()


func check_pellet_capacity():
	if pellets_on_screen >= max_pellets:
		at_pellet_capacity = true
	else:
		at_pellet_capacity = false


func _on_pellet_spawned():
	pellets_on_screen += 1
	check_pellet_capacity()


func _on_pellet_despawned():
	pellets_on_screen -= 1
	check_pellet_capacity()

func _on_feeding_timer_timeout()->void:
	can_feed = true
	

func _on_input_event(_viewport, event, _shape_idx)->void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			for area in get_overlapping_areas():
				print(area.name)
				if area.is_in_group("zeni"):
					return
			drop_pellet()
