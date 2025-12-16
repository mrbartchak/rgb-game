class_name Bullet
extends Area2D

@export var bullet_stats: BulletStats
var bullet_velocity: Vector2

func _ready() -> void:
	var direction = Vector2.DOWN.rotated(rotation)
	bullet_velocity = bullet_stats.speed * direction
	$Sprite2D.texture = bullet_stats.texture
	$Sprite2D.modulate = bullet_stats.color
	$Sprite2D/Trail.default_color = bullet_stats.color

func _physics_process(delta: float) -> void:
	position -= bullet_velocity * delta
	if position.y < 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area == null:
		return
	queue_free()
