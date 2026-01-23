extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -600.0

@onready var sprite = get_node("Sprite2D")
@onready var anim_player = get_node("AnimationPlayer")
@onready var hurtbox_col = get_node("Hurtbox/CollisionShape2D")
@onready var audio_player = get_node("AudioStreamPlayer")
@onready var audio_player2 = get_node("AudioStreamPlayer2")
@onready var audio_player3 = get_node("AudioStreamPlayer3")
@onready var audio_player4 = get_node("AudioStreamPlayer4")

@onready var healthbar = $CanvasLayer/Healthbar

var health = 100
var can_attack = true
var knockback_const = 1000.0
var knockback = 0.0
var push_force = 400.0

var is_jumping = false
var is_attacking = false
var is_falling = false
var ouching = false
var current_anim = "idle"

func _ready() -> void:
	healthbar.init_health(health)

func _physics_process(delta: float) -> void:
	hurtbox_col.disabled = false
	
	current_anim = anim_player.get_current_animation()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jumping = false
		is_falling = false
	
	_handle_input()
	
	knockback = lerp(knockback, 0.0, 0.2)
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)


func _handle_input() -> void:
	if Input.is_action_just_pressed("p2_jump") and is_on_floor() and current_anim != "attack":
		anim_player.play("jumping")
		is_jumping = true
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("p2_left", "p2_right")
	
	if Input.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://Scenes/pause_screen.tscn")
	
	if direction:
		if not is_jumping and not is_attacking and not ouching:
			anim_player.play("walk")
		velocity.x = direction * SPEED + knockback
		sprite.scale.x = direction * abs(sprite.scale.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) + knockback
		if not is_jumping and not is_attacking and not ouching:
			anim_player.play("idle")
		
	if is_falling:
		anim_player.play("falling")
	
	if Input.is_action_just_pressed("p2_attack") and can_attack:
		if randi_range(0, 5) == 0:
			audio_player2.play()
		audio_player4.play()
		
		is_falling = false
		anim_player.play("attack")
		is_attacking = true
	
	if Input.is_action_pressed("p2_block") and current_anim != "attack":
		anim_player.play("blocking")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		can_attack = false
		hurtbox_col.disabled = true
	else:
		can_attack = true
		
	if anim_player.get_queue().is_empty() and not anim_player.is_playing():
		anim_player.queue("idle")
	

func _on_hitbox_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(sign(sprite.scale.x))
	audio_player3.play()

func take_damage(dir):
	anim_player.play("ouch")
	audio_player.play()
	ouching = true
	knockback = dir * knockback_const
	
	health -= 5 + randi_range(0, 5)
	
	if (health <= 0):
		get_tree().change_scene_to_file("res://scenes/end_screen_p2.tscn")
	
	healthbar.health = health
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
	if anim_name == "jumping":
		is_falling = true
	if anim_name == "ouch":
		ouching = false
