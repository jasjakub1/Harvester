extends Sprite2D

var abilities = ["wall jump", "sword", "dash", "none", "double jump", "gravity", "flight", "teleport", "mini curse", "none"]

func update_ability() -> void:
	frame = abilities.find($"../../..".ability)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
