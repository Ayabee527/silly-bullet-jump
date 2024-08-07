class_name ProjectileData
extends AttackData

@export_group("Basic Properties")
@export var life_time: float = 2.0
@export var start_speed: float = 384.0
@export var end_speed: float = 384.0
@export var accel_time: float = 0.0
@export var radius: float = 3.0
@export var max_pierces: float = 0

@export_group("Homing")
@export var homes: bool = false
@export var targets: Array[String] = ["enemies"]
@export var turn_speed: float = 360.0

@export_group("Graphics")
@export var in_texture: Texture2D
@export var out_texture: Texture2D
@export var color: Color = Color.WHITE
