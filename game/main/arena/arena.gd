class_name Arena
extends Area2D

signal resize_started(radius: float)
signal resize_finished(radius: float)

@export var color: Color = Color(0.259, 0.259, 0.259)
@export var radius: float = 256.0:
	set = set_radius

@export_group("Inner Dependencies")
@export var shape: Polygon2D
@export var collision: CollisionShape2D

var last_radius: float = 256.0
var detail: int = 32

func _ready() -> void:
	shape.color = color
	update_arena(radius)

func generate() -> void:
	pass

func set_radius(new_radius: float) -> void:
	radius = new_radius
	resize_started.emit(radius)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_method(
		update_arena, last_radius, radius, 3.0
	) 
	last_radius = radius
	await tween.finished
	resize_finished.emit(radius)

func update_arena(new_radius: float) -> void:
	var points := PackedVector2Array()
	for i: int in range(detail):
		var ang = (float(i) / detail) * TAU
		var point = Vector2.from_angle(ang) * new_radius
		points.append(point)
	shape.polygon = points
	
	var shape = CircleShape2D.new()
	shape.radius = new_radius
	collision.shape = shape
	
	MainCam.shake(1, 15, 15)
