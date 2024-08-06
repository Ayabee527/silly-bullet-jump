extends Node2D

@export var arena: Arena

func _ready() -> void:
	arena.radius = 102.4

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and OS.is_debug_build():
		get_tree().reload_current_scene()
