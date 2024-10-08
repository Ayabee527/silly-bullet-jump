class_name Weapon
extends Resource

@export var attack: PackedScene
@export var color: Color = Color.WHITE
@export var spread: float = 0.0
@export var rotation_offset: float = 0.0
@export var shots_per: int = 1
@export var angle_per_shot: float = 0.0
@export var cool_down: float = 0.1
@export var camera_shake_shake: float = 5
@export var camera_shake_speed: float = 15
@export var camera_shake_decay: float = 15
@export var payload: Weapon
