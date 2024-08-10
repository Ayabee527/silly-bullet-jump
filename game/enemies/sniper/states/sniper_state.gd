class_name SniperEnemyState
extends State

var enemy: SniperEnemy

func _ready() -> void:
	await owner.ready
	enemy = owner as SniperEnemy
	assert(enemy != null)
