extends CharacterBody2D

const gravity = 1400
const acceleration = 50
const jump_height = 600
var speed = 0
var nograv = false
const maxspeed = 250
const decelleration = 40
const dash_speed = 250
var ability = "dash"
var double_jump = true
var isDashing = false

@onready var animation = $AnimatedSprite2D


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("left", "right")
	if not isDashing:
		if direction > 0:
			animation.flip_h = false
		elif direction < 0:
			animation.flip_h = true
	
	if not is_on_floor():
		animation.play("fall")
	elif direction != 0:
		animation.play("run")
	else:
		animation.play("idle")
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -1 * jump_height
		elif (ability == "double jump") and (double_jump == true):
			velocity.y = -1 * jump_height
			double_jump = false
	if is_on_floor():
		double_jump = true
	
	if direction:
		speed = clamp(speed + direction * acceleration, -1 * maxspeed, maxspeed)
	elif speed > 0:
		speed -= decelleration
	elif speed < 0:
		speed += decelleration
	if abs(speed) < 40:
		speed = 0
	
	if Input.is_action_just_pressed("ability") and (ability == "dash"):
		isDashing = true
	
	if isDashing:
		velocity = Vector2(-2*(int(animation.flip_h)-0.5) * dash_speed, 0)
		if Input.is_action_just_released("ability"):
			isDashing = false
			ability = null
	else:
		velocity.x = speed
	
	move_and_slide()
