extends Area2D

@onready var playerNode = $"../.."
@onready var sprite = $"../Sprite2D"
var timer = 0

func slash() -> void:
	var direction = -2*(int($"../../AnimatedSprite2D".flip_h)-0.5)
	$"..".position = Vector2(direction*40, 20)
	$"CollisionShape2D".position = Vector2.RIGHT * direction * 15
	if direction > 0:
		sprite.rotation_degrees = 45
	if direction < 0:
		sprite.rotation_degrees = -135
	sprite.visible = true
	timer = 0.5

func testEnemies() -> void:
	var bodies = get_overlapping_areas()
	for i in bodies:
		i.eliminate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ability") and playerNode.ability == "sword":
		slash()
	if timer > 0:
		testEnemies()
		timer -= delta
		
	else:
		sprite.visible = false
	
	
