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
@export var weapon_handler: WeaponHandler
@export var hurtbox: Hurtbox
@export var hurtbox_collision: CollisionShape2D
@export var hurt_player: AnimationPlayer

var has_spawned: bool = false

func _ready() -> void:
	MainCam.target = self

func _physics_process(delta: float) -> void:
	var look_transform = global_transform.looking_at(get_global_mouse_position())
	global_transform = global_transform.interpolate_with(
		look_transform, delta * 10.0
	)
	
	if has_spawned:
		if Input.is_action_just_pressed("shoot"):
			weapon_handler.firing = true
		elif Input.is_action_just_released("shoot"):
			weapon_handler.firing = false
	
	move_and_slide()

func get_move_vector() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _on_height_sprite_height_changed(new_height: float) -> void:
	weapon_handler.position = sprite.offset
	hurtbox_collision.position = sprite.offset
	hurtbox.height = new_height


func _on_health_was_hurt(new_health: int, amount: int) -> void:
	if new_health > 0:
		hurt_player.play("hurt")
		MainCam.shake(30, 15, 5)
