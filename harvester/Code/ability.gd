extends Sprite2D
@onready var playerscript = $"../../.."
var abilities = ["wall jump", "sword", "dash", "none", "double jump", "gravity", "flight", "teleport", "mini curse", "none"]

func update_ability() -> void:
	var textList = ["Wall Jump", "Sword", "Dash, 1 use, hold button to use", "", "Double Jump", "Reverse Gravity, " + str(playerscript.gravityUses) + " use(s) remaining", "Free Flight, " + str(int(playerscript.isFlying) * int(ceil(playerscript.flyingTimer)) + 2 * int(not playerscript.isFlying)) + " second(s) left", "Teleport, 1 use left", "Cursed! Smaller Size!", ""]
	var ind = abilities.find(playerscript.ability)
	frame = ind
	$"../AbilityDescription".text = textList[ind]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
