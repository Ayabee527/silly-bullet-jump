class_name HeightSprite
extends Sprite2D

@export var height: float = 0.0
@export var bounce: float = 0.0

var jump_velocity : float = 0.0
var jump_gravity : float = 98
var fall_gravity : float = 98

var speed: float = 0.0

func _process(delta: float) -> void:
	height -= speed * delta
	offset = Vector2(0, -height).rotated(-global_rotation)
	
	if height < 1.0 and not is_zero_approx(speed):
		speed *= -bounce
		height = max(0.0, height)
	
	if height > 0.0:
		speed += get_gravity() * delta

func get_gravity() -> float:
	return jump_gravity if speed < 0.0 else fall_gravity

func jump(jump_height: float, jump_time_to_peak: float, jump_time_to_fall: float) -> void:
	jump_velocity = 0.0
	jump_gravity = 98
	fall_gravity = 98
	
	if jump_time_to_peak == 0.0 and jump_time_to_fall == 0.0:
		return
	
	if jump_time_to_peak > 0.0:
		jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
		jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
		fall_gravity = jump_gravity
	if jump_time_to_fall > 0.0:
		fall_gravity = ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0
		if jump_time_to_peak <= 0.0:
			jump_gravity = fall_gravity
	
	prints(jump_velocity, jump_gravity, fall_gravity)
	
	if jump_velocity != 0.0:
		speed = jump_velocity
	else:
		speed = 0.0
		height = jump_height
