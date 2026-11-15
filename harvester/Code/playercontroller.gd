extends CharacterBody2D

var gravity = 1600
const acceleration = 50
var jump_height = 600
var speed = 0
var nograv = false
var maxspeed = 250
const flightspeed = 200
const decelleration = 40
const dash_speed = 250
var ability = "none"
var prevAbility = "none"
var double_jump = true
var isDashing = false
var animation_buffer = 0
var dashDistance = 100
@onready var checkpoint = position
var isFlying = true
var flyingTimer = 0
var flipped = false
var vertMult = -1
var gravityUses = 2
var wall_jump_velocity = 0
var movement_enabled = true
@onready var fade = $"../CanvasLayer/ColorRect"

@onready var groundCheck = $groundCheck
@onready var groundCheck2 = $groundCheck2
@onready var wallLeft = $wallCheckLeft
@onready var wallRight = $wallCheckRight
@onready var animation = $AnimatedSprite2D
@onready var gameManager = $"../GameManager"
@onready var ui = $"Camera2D/CanvasLayer/Ability"
@onready var pop = $"../CanvasLayer/Sprite2D"

func grounded() -> bool:
	if flipped:
		var grounded = false
		vertMult = 1
		animation.flip_v = true
		if groundCheck.is_colliding():
			var collider = groundCheck.get_collider()
			if collider.name == "TileMapLayer":
				grounded = true
		if groundCheck2.is_colliding():
			var collider = groundCheck2.get_collider()
			if collider.name == "TileMapLayer":
				grounded = true
		return grounded
	else:
		vertMult = -1
		animation.flip_v = false
		return is_on_floor()

func death(cause: String, override = false) -> void:
	prevAbility = ability
	$music.Mute()
	$powerDown.Play()
	movement_enabled = false
	isDashing = false
	isFlying = false
	flyingTimer = 0
	if cause == "crush":
		ability = "flight"
	elif cause == "void":
		ability = "double jump"
	elif cause == "sky":
		ability = "teleport"
	elif cause == "spikes":
		ability = "sword"
	if override:
		ability = cause
	if ability == "gravity":
		gravityUses = 2
	velocity = Vector2.ZERO
	
	pop.fadeout()
	fade.fadeout()
	await get_tree().create_timer(1.0).timeout
	ui.update_ability()
	
	position = checkpoint
	$powerUp.Play()
	fade.fadein()
	pop.fadein()
	await get_tree().create_timer(1.0).timeout
	movement_enabled = true

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	grounded()
	if isFlying:
		if flyingTimer <=0:
			isFlying = false
			movement_enabled = true
		else:
			flyingTimer -= delta
			if flyingTimer <= 0:
				ability = "none"
		ui.update_ability()
	
	if ability == "mini curse":
		scale = Vector2(0.3, 0.3)
		maxspeed = 100
		jump_height = 300
	else:
		scale = Vector2(0.6,0.6)
		maxspeed = 250
		jump_height = 600
	
	if Input.is_action_just_pressed("checkpoint") and is_on_floor():
		$"../CheckpointFlag".position = position
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
		elif not grounded():
			animation.play("fall")
		elif direction != 0:
			animation.play("run")
		else:
			animation.play("idle")
	else:
		animation_buffer -= 1
	
	if not grounded():
		velocity.y -= gravity * delta * vertMult
		
	if Input.is_action_just_pressed("jump"):
		if grounded():
			velocity.y = vertMult * jump_height
		elif (ability == "double jump") and (double_jump == true):
			velocity.y = vertMult * jump_height
			double_jump = false
			animation.play("dash", 3.0)
			animation_buffer = 16
	var slowgrav = false
	if ability == "wall jump":
		if wallLeft.is_colliding():
			if wallLeft.get_collider().name == "TileMapLayer":
				wall_jump_velocity = 0
				if velocity.y >= 0:
					slowgrav = true
				else:
					slowgrav = false
				if Input.is_action_just_pressed("jump"):	
					velocity.y = vertMult * jump_height * 1
					wall_jump_velocity = 500
		if wallRight.is_colliding():
			if wallRight.get_collider().name == "TileMapLayer":
				wall_jump_velocity = 0
				if velocity.y >= 0:
					slowgrav = true
				else:
					slowgrav = false
				if Input.is_action_just_pressed("jump"):	
					velocity.y = vertMult * jump_height * 1
					wall_jump_velocity = -500
		if slowgrav:
			gravity = 400
			velocity.y = clamp(velocity.y, -20000, 100)
		else:
			gravity = 1600
	if grounded():
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
		velocity = Vector2(0.5*direction, vertDirection) * flightspeed
	
	if Input.is_action_just_pressed("ability"):
		
		if (ability == "flight") and not isFlying:

			isFlying = true
			movement_enabled = false
			flyingTimer = 2
			speed = 0
		
		if ability == "gravity":
			flipped = not flipped
			gravityUses -= 1
			if gravityUses == 0:
				ability = "none"
			ui.update_ability()
		
		if ability == "dash":
			isDashing = true
			
		if ability == "teleport":
			position.x += -2 * (int(animation.flip_h)-0.5) * dashDistance
			ability = "none"
			if not gameManager._has_exited_floor():
				death("crush")
			ui.update_ability()
			
	
	if isDashing:
		velocity = Vector2(-2*(int(animation.flip_h)-0.5) * dash_speed, 0)
		if Input.is_action_just_released("ability"):
			isDashing = false
			ability = "none"
			ui.update_ability()
	elif movement_enabled:
		velocity.x = speed
		velocity.x += wall_jump_velocity
		if wall_jump_velocity > 0:
			wall_jump_velocity -= 10
		if wall_jump_velocity < 0:
			wall_jump_velocity += 10
	
	move_and_slide()




func _on_music_ready() -> void:
	$music.Play()
