class_name Hurtbox
extends Area2D

signal hurt(hitbox: Hitbox)

@export var height: float = 0.0
@export var height_radius: float = 0.0

@export_group("Outer Dependencies")
@export var health: Health

@export_group("Inner Dependencies")
@export var invinc_timer: Timer

var active_hitboxes: Array[Hitbox] = []

func _process(delta: float) -> void:
	if active_hitboxes.size() > 0:
		if invinc_timer.is_stopped():
			take_damage()

func take_damage() -> void:
	var chosen_hitbox: Hitbox = active_hitboxes.back() as Hitbox
	
	if chosen_hitbox.height_based:
		if not is_in_height_range(chosen_hitbox):
			return
	
	health.hurt(chosen_hitbox.damage)
	
	invinc_timer.start(chosen_hitbox.damage_cooldown)

func is_in_height_range(hitbox: Hitbox) -> bool:
	var range = height_radius + hitbox.height_radius
	#prints(height, hitbox.height, range)
	
	return abs(height - hitbox.height) <= range

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and not active_hitboxes.has(area) and not area.owner == owner:
		area = area as Hitbox
		active_hitboxes.append(area)
		hurt.emit(area)


func _on_area_exited(area: Area2D) -> void:
	active_hitboxes.erase(area)
