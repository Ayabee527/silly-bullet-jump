class_name ExplosionAttack
extends Node2D

@export_group("Data")
@export var collision_data: CollisionData
@export var attack_data: ExplosionData

@export_group("Inner Dependencies")
@export var shape: Polygon2D
@export var shadow: Polygon2D
@export var hitbox: Hitbox
@export var hitbox_collision: CollisionShape2D
@export var sustain_timer: Timer
@export var debri: GPUParticles2D

func _ready() -> void:
	global_rotation = 0
	
	var points := PackedVector2Array()
	for i: int in range(attack_data.sides):
		var ang = (float(i) / attack_data.sides) * TAU
		var point = Vector2.from_angle(ang) * attack_data.radius
		points.append(point)
	shape.polygon = points
	shadow.polygon = points
	
	shape.color = attack_data.color
	debri.modulate = attack_data.color
	
	hitbox.damage = attack_data.hitbox_data.damage
	hitbox.damage_cooldown = attack_data.hitbox_data.damage_cooldown
	
	var col_shape = CircleShape2D.new()
	col_shape.radius = attack_data.radius
	hitbox_collision.shape = col_shape
	
	#hitbox.collision_layer = collision_data.collision_layer
	#hitbox.collision_mask = collision_data.collision_mask
	
	debri.restart()
	sustain_timer.start(attack_data.sustain_time)

func fade() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(
		shape, "scale",
		Vector2.ZERO, attack_data.fade_time
	).from(Vector2.ONE)
	tween.tween_property(
		shadow, "scale",
		Vector2.ZERO, attack_data.fade_time
	).from(Vector2.ONE)
	tween.tween_property(
		hitbox, "scale",
		Vector2.ZERO, attack_data.fade_time
	).from(Vector2.ONE)
	tween.play()
	
	await tween.finished
	hitbox_collision.set_deferred("disabled", true)
	attack_data.expired.emit()


func _on_sustain_timer_timeout() -> void:
	fade()
