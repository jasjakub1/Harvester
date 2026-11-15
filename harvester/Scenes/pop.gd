extends Sprite2D

@onready var abilities = $"../../CharacterBody2D/Camera2D/CanvasLayer/Ability".abilities
@onready var playerscript = $"../../CharacterBody2D"

func fadeout() -> void:
	frame = abilities.find(playerscript.prevAbility)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 2, 1)

func fadein() -> void:
	frame = abilities.find(playerscript.ability)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
