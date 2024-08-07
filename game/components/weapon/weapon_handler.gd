class_name WeaponHandler
extends Node2D

signal fired()

@export var weapons: Array[Weapon]:
	set = set_weapons

@export_group("Inner Dependencies")
@export var dazzle: GPUParticles2D
@export var muzzle: Marker2D
@export var fire_timer: Timer

var firing: bool = false:
	set = set_firing
var weapon_idx: int = 0

func set_weapons(new_weapons: Array[Weapon]) -> void:
	weapons = new_weapons
	weapon_idx = 0

func set_firing(new_firing: bool) -> void:
	firing = new_firing
	if firing and fire_timer.is_stopped():
		shoot()

func shoot() -> void:
	var weapon: Weapon = weapons[weapon_idx]
	
	fire_timer.start(weapon.cool_down)
	weapon_idx += 1
	weapon_idx = wrapi(weapon_idx, 0, weapons.size() - 1)

func update_dazzle(color: Color) -> void:
	dazzle.modulate = color

func unleash_payload(carrier: Node2D, payload: Weapon) -> void:
	pass

func _on_fire_timer_timeout() -> void:
	if firing:
		shoot()
