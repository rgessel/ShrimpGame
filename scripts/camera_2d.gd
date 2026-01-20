extends Camera2D

@onready var p1 = get_node("../Player1")
@onready var p2 = get_node("../Player2")

var camera_speed = 0.1
var zoom_speed = 0.1
var zoom_offset = 0.2
var hcamera_offset = -200


func _ready() -> void:
	global_position = Vector2(0, 0)
	

func _process(_delta: float) -> void:
	var x = clamp(1.5 - 0.002 * abs(global_position.x - p1.global_position.x), 0.75, 1.5)
	var new_zoom = Vector2(x, x)
	
	global_position = lerp(global_position, calculate_center(p1, p2), camera_speed)
	zoom = lerp(zoom, new_zoom, zoom_speed)


func calculate_center(point1, point2) -> Vector2:
	return Vector2(
		(point1.global_position.x + point2.global_position.x) / 2,
		(point1.global_position.y + point2.global_position.y + hcamera_offset) / 2
		)

func calculate_zoom(rect, viewport_size) -> Vector2:
	var max_zoom = max(
		max(1, rect.size.x / viewport_size.x + zoom_offset),
		max(1, rect.size.y / viewport_size.y + zoom_offset)
	)
	return Vector2(max_zoom, max_zoom)
