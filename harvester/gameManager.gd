extends Node2D

@onready var playerNode = $"../CharacterBody2D"
@onready var playerBody = $"../CharacterBody2D/CollisionShape2D"

@onready var floorlayer = $"../TileMapLayer"

func _has_exited_floor() -> bool:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsShapeQueryParameters2D.new()
	params.set_shape(playerBody.shape)
	params.transform = playerNode.transform
	params.collision_mask = 1 << (1 - 1)  # Only query floor layer
	  
	var results = space_state.intersect_shape(params, 1)
	return results.is_empty()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
