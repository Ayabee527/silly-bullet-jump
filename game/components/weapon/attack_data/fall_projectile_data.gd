class_name FallProjectileData
extends AttackData

@export_group("Basics")
@export var start_speed: float = 128.0
@export var end_speed: float = 128.0
@export var accel_time: float = 0.0
@export var radius: float = 4.0

@export_group("Homing")
@export var homes: bool = false
@export var targets: Array[String] = ["enemies"]
@export var turn_speed: float = 360.0

@export_group("Gravity")
@export var peak_height: float = 32.0
@export var time_to_peak: float = 0.5
@export var time_to_fall: float = 0.5
@export var max_bounces: int = 0
@export var bounce_factor: float = 0.5

@export_group("Graphics")
@export var in_texture: Texture2D
@export var out_texture: Texture2D
@export var color: Color = Color.WHITE
