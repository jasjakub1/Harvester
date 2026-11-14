extends Area2D

var danger = true

@onready var playerNode = $"../../CharacterBody2D"

func eliminate() -> void:
	$"../Sprite2D".visible = false
	danger = false

func _on_body_entered(body: Node2D) -> void:
	if body == playerNode and danger:
		playerNode.death($"..".get_meta("ability_provided"), true)
