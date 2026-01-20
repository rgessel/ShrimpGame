extends StaticBody2D

@export var health = 3
@onready var anim_player = get_node("AnimationPlayer")

func _physics_process(_delta: float) -> void:
	if health == 3:
		anim_player.play("crumble1")
	elif health == 2:
		anim_player.play("crumble2")
	elif health == 1:
		anim_player.play("crumble3")
	else:
		queue_free()

func take_damage(_dir):
	health -= 1
