class_name SniperEnemy
extends CharacterBody2D

@export_group("Inner Dependencies")
@export var sprite: HeightSprite
@export var weapon_handler: WeaponHandler
@export var hurtbox: Hurtbox
@export var hurtbox_collision: CollisionShape2D
@export var hurt_player: AnimationPlayer

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_height_sprite_height_changed(new_height: float) -> void:
	hurtbox.height = new_height
	hurtbox_collision.position = sprite.offset
	weapon_handler.position = sprite.offset


func _on_health_was_hurt(new_health: int, amount: int) -> void:
	if new_health > 0.0:
		hurt_player.play("hurt")
		MainCam.shake(5.0 * amount, 15, 5.0 * amount)
