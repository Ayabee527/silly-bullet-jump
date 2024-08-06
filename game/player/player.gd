class_name Player
extends CharacterBody2D

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var shadow: Shadow

func _ready() -> void:
	#await get_tree().create_timer(1.0).timeout
	sprite.jump(256.0, 0.0, 1.0)
