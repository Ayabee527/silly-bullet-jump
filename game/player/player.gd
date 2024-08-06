class_name Player
extends CharacterBody2D

signal spawned()

@export var move_speed: float = 128.0
@export var jump_height: float = 32.0
@export var jump_time_to_peak: float = 0.25
@export var jump_time_to_fall: float = 0.25

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var shadow: Shadow
@export var land_particles: GPUParticles2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var look_transform = global_transform.looking_at(get_global_mouse_position())
	global_transform = global_transform.interpolate_with(
		look_transform, delta * 10.0
	)
	
	move_and_slide()

func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
