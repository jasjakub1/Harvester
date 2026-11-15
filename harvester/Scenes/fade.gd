extends ColorRect

@onready var list = $"../../CharacterBody2D/Camera2D/CanvasLayer2/Sprite2D".frame

func fadeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "color:a", 2, 1)

func fadein() -> void:
	var tween = create_tween()
	tween.tween_property(self, "color:a", 0, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
