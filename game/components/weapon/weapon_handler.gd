class_name WeaponHandler
extends Node2D

signal fired()

@export var muzzle_distance: float = 8.0
@export var collision_data: CollisionData

@export var weapons: Array[Weapon]:
	set = set_weapons

@export_group("Inner Dependencies")
@export var dazzle: GPUParticles2D
@export var flash: GPUParticles2D
@export var muzzle: Marker2D
@export var fire_timer: Timer

var firing: bool = false:
	set = set_firing
var weapon_idx: int = 0:
	set = set_weapon_idx

func _ready() -> void:
	muzzle.position = Vector2.RIGHT * muzzle_distance

func set_weapon_idx(new_weapon_idx: int) -> void:
	weapon_idx = new_weapon_idx
	if weapons.size() > 0:
		if weapons[weapon_idx] != null:
			update_dazzle(weapons[weapon_idx].color)

func set_weapons(new_weapons: Array[Weapon]) -> void:
	weapons = new_weapons
	weapon_idx = 0

func set_firing(new_firing: bool) -> void:
	firing = new_firing
	if firing and fire_timer.is_stopped():
		shoot()

func shoot() -> void:
	var weapon: Weapon = weapons[weapon_idx]
	if weapon == null:
		weapon_idx = wrapi(weapon_idx + 1, 0, weapons.size())
		return
	
	for i: int in range(weapon.shots_per):
		var attack = weapon.attack.instantiate() as Node2D
		var attack_data = weapon.attack_data.duplicate()
		if "attack_data" in attack:
			attack.attack_data = attack_data
		
		var shoot_angle = weapon.rotation_offset + (weapon.angle_per_shot * i)
		
		attack.collision_data = collision_data
		attack.global_position = muzzle.global_position
		attack.global_rotation = muzzle.global_rotation
		attack.global_rotation += deg_to_rad(shoot_angle)
		attack.global_rotation += deg_to_rad(
			randf_range(-weapon.spread, weapon.spread)
		)
		
		if weapon.payload:
			attack_data.expired.connect( unleash_payload.bind(attack, weapon.payload) )
			attack_data.trigger_payload.connect( unleash_payload.bind(attack, weapon.payload) )
		
		get_tree().current_scene.add_child(attack)
	
	MainCam.shake(weapon.camera_shake, 15, 15)
	flash.restart()
	weapon_idx = wrapi(weapon_idx + 1, 0, weapons.size())
	if weapon.cool_down > 0.0:
		fire_timer.start(weapon.cool_down)
	else:
		await get_tree().physics_frame
		if firing:
			shoot()

func update_dazzle(color: Color) -> void:
	dazzle.modulate = color
	flash.modulate = color

func unleash_payload(carrier: Node2D, payload: Weapon) -> void:
	for i: int in range(payload.shots_per):
		var attack = payload.attack.instantiate() as Node2D
		var attack_data = payload.attack_data.duplicate()
		if "attack_data" in attack:
			attack.attack_data = attack_data
		
		var shoot_angle = payload.rotation_offset + (payload.angle_per_shot * i)
		
		attack.collision_data = collision_data
		attack.global_position = carrier.global_position
		attack.global_rotation = carrier.global_rotation
		attack.global_rotation += deg_to_rad(shoot_angle)
		attack.global_rotation += deg_to_rad(
			randf_range(-payload.spread, payload.spread)
		)
		
		if payload.payload:
			attack_data.expired.connect( unleash_payload.bind(attack, payload.payload) )
			attack_data.trigger_payload.connect( unleash_payload.bind(attack, payload.payload) )
		
		get_tree().current_scene.add_child(attack)

func _on_fire_timer_timeout() -> void:
	if firing:
		shoot()
