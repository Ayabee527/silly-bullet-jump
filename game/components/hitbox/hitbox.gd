class_name Hitbox
extends Area2D

signal hit(hurtbox: Hurtbox)

@export var damage: int = 1
@export var damage_cooldown: float = 0.5

@export var height_based: bool = true
@export var height: float = 0.0
@export var height_radius: float = 0.0
