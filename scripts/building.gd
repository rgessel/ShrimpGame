extends StaticBody2D

@export var health = 3
@onready var anim_player = get_node("AnimationPlayer")
@onready var audio_player = get_node("AudioStreamPlayer")

func _physics_process(_delta: float) -> void:
	if health == 3:
		anim_player.queue("crumble1")
	elif health == 2:
		anim_player.queue("crumble2")
	elif health == 1:
		anim_player.queue("crumble3")
	else:
		anim_player.play("sink")

func take_damage(_dir):
	health -= 1
	audio_player.play()
	anim_player.play("rumble")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "sink"):
		audio_player.stop()
		queue_free()
