class_name Hurtbox
extends Area2D

signal hurt(hitbox: Hitbox)

@export_group("Outer Dependencies")
@export var health: Health

@export_group("Inner Dependencies")
@export var invinc_timer: Timer

var active_hitboxes: Array[Hitbox] = []:
	set = set_active_hitboxes

func set_active_hitboxes(new_active_hitboxes: Array[Hitbox]) -> void:
	active_hitboxes = new_active_hitboxes
	if active_hitboxes.size() > 0:
		if invinc_timer.is_stopped():
			take_damage()

func take_damage() -> void:
	var chosen_hitbox: Hitbox = active_hitboxes.back() as Hitbox
	
	health.hurt(chosen_hitbox.damage)
	
	invinc_timer.start(chosen_hitbox.damage_cooldown)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and not active_hitboxes.has(area) and not area.owner == owner:
		area = area as Hitbox
		active_hitboxes.append(area)
		hurt.emit(area)


func _on_area_exited(area: Area2D) -> void:
	active_hitboxes.erase(area)
