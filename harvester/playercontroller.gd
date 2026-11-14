extends CharacterBody2D

const gravity = 1600
const acceleration = 50
var jump_height = 600
var speed = 0
var nograv = false
var maxspeed = 250
const flightspeed = 200
const decelleration = 40
const dash_speed = 250
var ability = "double jump"
var teleportUses = 2
var double_jump = true
var isDashing = false
var animation_buffer = 0
var dashDistance = 100
@onready var checkpoint = position
var isFlying = true
var flyingTimer = 0

@onready var animation = $AnimatedSprite2D
@onready var gameManager = $"../GameManager"

func death(cause: String) -> void:
	if cause == "crush":
		ability = "flight"
	elif cause == "sky":
		ability = "teleport"
		teleportUses = 2
	velocity = Vector2.ZERO
	position = checkpoint

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if flyingTimer <=0:
		isFlying = false
	else:
		flyingTimer -= delta
	
	if ability == "mini curse":
		scale = Vector2(0.3, 0.3)
		maxspeed = 100
		jump_height = 300
	else:
		scale = Vector2(0.6,0.6)
		maxspeed = 250
		jump_height = 600
	
	if Input.is_action_just_pressed("checkpoint"):
		checkpoint = position
	
	var direction = Input.get_axis("left", "right")
	if not isDashing:
		if direction > 0:
			animation.flip_h = false
		elif direction < 0:
			animation.flip_h = true
			
	if not animation_buffer:
		if isDashing:
			animation.play("dash")
		elif not is_on_floor():
			animation.play("fall")
		elif direction != 0:
			animation.play("run")
		else:
			animation.play("idle")
	else:
		animation_buffer -= 1
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -1 * jump_height
		elif (ability == "double jump") and (double_jump == true):
			velocity.y = -1 * jump_height
			double_jump = false
			animation.play("dash", 3.0)
			animation_buffer = 16
	if is_on_floor():
		double_jump = true
	if not isFlying:
		if direction:
			speed = clamp(speed + direction * acceleration, -1 * maxspeed, maxspeed)
		elif speed > 0:
			speed -= decelleration
		elif speed < 0:
			speed += decelleration
		if abs(speed) < 40:
			speed = 0
	if isFlying:
		var vertDirection = Input.get_axis("up", "down")
		velocity = Vector2(direction, vertDirection) * flightspeed
	
	if Input.is_action_just_pressed("ability"):
		
		if ability == "flight":
			isFlying = true
			flyingTimer = 3
			speed = 0
			ability = null
		
		if ability == "dash":
			isDashing = true
			
		if (ability == "teleport") and teleportUses != 0:
			teleportUses -= 1
			position.x += -2 * (int(animation.flip_h)-0.5) * dashDistance
			if not gameManager._has_exited_floor():
				death("crush")
			
	
	if isDashing:
		velocity = Vector2(-2*(int(animation.flip_h)-0.5) * dash_speed, 0)
		if Input.is_action_just_released("ability"):
			isDashing = false
			ability = null
	elif not isFlying:
		velocity.x = speed
	
	move_and_slide()
