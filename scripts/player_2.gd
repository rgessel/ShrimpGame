extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite = get_node("Sprite2D")
@onready var anim_player = get_node("AnimationPlayer")
@onready var hurtbox_col = get_node("Hurtbox/CollisionShape2D")

var can_attack = true
var knockback_const = 500.0
var knockback = 0.0

func _physics_process(delta: float) -> void:
	hurtbox_col.disabled = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_handle_input()
	
	knockback = lerp(knockback, 0.0, 0.2)
	
	move_and_slide()

func _handle_input() -> void:
	if Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("p2_left", "p2_right")
	
	if direction:
		velocity.x = direction * SPEED + knockback
		sprite.scale.x = direction * abs(sprite.scale.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) + knockback
	
	if Input.is_action_just_pressed("p2_attack") and can_attack:
		anim_player.play("attack")
	
	if Input.is_action_pressed("p2_block"):
		print("blocking")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		can_attack = false
		hurtbox_col.disabled = true
	else:
		can_attack = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("p2 dealt damage")
	area.get_parent().take_damage(sign(sprite.scale.x))

func take_damage(dir):
	knockback = dir * knockback_const
	print("p2 ouch!")
