extends StaticBody2D

@export var health = 3

func _physics_process(_delta: float) -> void:
	if health < 0:
		queue_free()

func take_damage(_dir):
	print("building ouch!")
	health -= 1
