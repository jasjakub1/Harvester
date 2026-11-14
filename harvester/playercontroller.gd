extends CharacterBody2D

const gravity = 100
const acceleration = 20
const jump_height = 100
var speed = 0
const maxspeed = 50
const decelleration = 20

@onready var animation = $AnimatedSprite2D


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	var direction = Input.get_axis("left", "right")
	
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
	
	if direction:
		speed = clamp(speed + direction * acceleration, -1 * maxspeed, maxspeed)
	elif speed > 0:
		speed -= decelleration
	elif speed < 0:
		speed += decelleration
	if abs(speed) < 5:
		speed = 0
	
	velocity.x = speed
	
	move_and_slide()
