extends Camera2D

@onready var p1 = get_node("../Player1")
@onready var p2 = get_node("../Player2")

var camera_speed = 0.1
var zoom_speed = 0.1
var zoom_offset = 0.2
var viewport_rect


func _ready() -> void:
	global_position = Vector2(0, 0)
	viewport_rect = get_viewport_rect()

func _process(_delta: float) -> void:
	var camera_rect = Rect2(p1.global_position, p2.global_position)
	
	offset = lerp(offset, calculate_center(camera_rect), camera_speed)
	zoom = lerp(zoom, calculate_zoom(camera_rect, viewport_rect.size), zoom_speed)


func calculate_center(rect) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2
		)

func calculate_zoom(rect, viewport_size) -> Vector2:
	var max_zoom = max(
		max(1, rect.size.x / viewport_size.x + zoom_offset),
		max(1, rect.size.y / viewport_size.y + zoom_offset)
	)
	return Vector2(max_zoom, max_zoom)
