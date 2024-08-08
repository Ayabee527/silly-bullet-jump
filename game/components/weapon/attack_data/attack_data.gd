class_name AttackData
extends Resource

signal expired()
signal trigger_payload()

@export var hitbox_data: HitboxData

var collision_layer: int
var collision_mask: int
