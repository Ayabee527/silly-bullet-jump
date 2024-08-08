class_name FallProjectile
extends Area2D

@export_group("Data")
@export var collision_data: CollisionData
@export var attack_data: FallProjectileData

@export_group("Inner Dependencies")
@export var outtie: HeightSprite
@export var innie: HeightSprite
@export var shadow: Shadow
@export var trail_holder: Marker2D
@export var trail: Trail
@export var expire_particles: GPUParticles2D

@export var hitbox: Hitbox
@export var collision: CollisionShape2D
@export var hitbox_collision: CollisionShape2D

var bounces: int = 0

var cur_speed: float = 0.0
var cur_accel_time: float = 0.0

var velocity: Vector2 = Vector2.ZERO
var target: Node2D

var expired: bool = false

func _ready() -> void:
	innie.texture = attack_data.in_texture
	outtie.texture = attack_data.out_texture
	
	outtie.modulate = attack_data.color
	trail.modulate = attack_data.color
	expire_particles.modulate = attack_data.color
	
	var shape = CircleShape2D.new()
	shape.radius = attack_data.radius
	collision.shape = shape
	hitbox_collision.shape = shape
	trail.width = (attack_data.radius - 1.0) * 2.0
	
	hitbox.damage = attack_data.hitbox_data.damage
	hitbox.damage_cooldown = attack_data.hitbox_data.damage_cooldown
	
	collision_layer = collision_data.collision_layer
	collision_mask = collision_data.collision_mask
	hitbox.collision_layer = collision_layer
	hitbox.collision_mask = collision_mask
	
	cur_speed = attack_data.start_speed
	
	find_target()
	
	outtie.bounce = attack_data.bounce_factor
	innie.bounce = attack_data.bounce_factor
	outtie.jump(
		attack_data.peak_height,
		attack_data.time_to_peak,
		attack_data.time_to_fall
	)
	innie.jump(
		attack_data.peak_height,
		attack_data.time_to_peak,
		attack_data.time_to_fall
	)
	for i: int in range(3):
		await get_tree().process_frame
	trail.length = 16
	trail.show()

func _physics_process(delta: float) -> void:
	if expired:
		return
	
	if attack_data.accel_time > 0.0:
		cur_speed = lerpf(
			attack_data.start_speed, attack_data.end_speed,
			cur_accel_time / abs(attack_data.accel_time)
		)
	if cur_accel_time < attack_data.accel_time:
		cur_accel_time += delta
		cur_accel_time = min(cur_accel_time, abs(attack_data.accel_time))
	
	velocity = Vector2.from_angle(global_rotation) * cur_speed
	global_position += velocity * delta

func home_on_target() -> void:
	var dir_to_target = global_position.direction_to(target.global_position)
	var angle_to = Vector2.from_angle(global_rotation).angle_to(dir_to_target)
	angle_to = rad_to_deg(angle_to)
	angle_to += randf_range(-attack_data.inaccuracy, attack_data.inaccuracy)
	var home_turn: float = signf(angle_to) * minf(
		abs(angle_to), abs(attack_data.max_turn_angle)
	)
	global_rotation_degrees += home_turn

func find_target() -> void:
	if get_tree():
		var targets: Array[Node2D] = []
		for group in attack_data.targets:
			targets.append_array(get_tree().get_nodes_in_group(group))
		var closest_dist: float = INF
		var closest_target: Node2D = null
		for c_target: Node2D in targets:
			var dist_to = global_position.distance_squared_to(c_target.global_position)
			if dist_to < closest_dist:
				closest_dist = dist_to
				closest_target = c_target
		
		target = closest_target
		if target != null:
			target.tree_exited.connect(find_target)

func expire() -> void:
	if expired:
		return
	
	attack_data.expired.emit()
	expired = true
	
	expire_particles.restart()
	shadow.hide()
	outtie.hide()
	innie.hide()
	trail.hide()
	
	await expire_particles.finished
	queue_free()

func _on_outtie_height_changed(new_height: float) -> void:
	trail_holder.position = outtie.offset
	#innie.height = new_height
	
	if new_height <= attack_data.radius:
		if hitbox_collision.disabled:
			hitbox_collision.set_deferred("disabled", false)
	else:
		if not hitbox_collision.disabled:
			hitbox_collision.set_deferred("disabled", true)


func _on_outtie_bounced() -> void:
	if expired:
		return
	
	bounces += 1
	
	if attack_data.trigger_payload_on_bounce:
		attack_data.trigger_payload.emit()
	trail.clear_points()
	find_target()
	
	if is_instance_valid(target) and attack_data.homes:
		home_on_target()
	
	if bounces > attack_data.max_bounces:
		expire()
