class_name HopperEnemyState
extends State

var enemy: HopperEnemy

func _ready() -> void:
	await owner.ready
	enemy = owner as HopperEnemy
	assert(enemy != null)
