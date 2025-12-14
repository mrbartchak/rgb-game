class_name BulletStats
extends Resource

@export var name: String
@export var damage: int = 10
@export var speed: float = 200.0
@export var texture: Texture2D
@export var bullet_scene: PackedScene

func spawn_bullet(origin: Node2D) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.bullet_stats = self
	bullet.global_position = origin.global_position
	origin.get_tree().current_scene.add_child(bullet)
