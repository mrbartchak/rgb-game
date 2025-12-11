class_name AttackStats
extends Resource

@export var name: String
@export var bullet_stats: BulletStats
@export var fire_rate: float

func fire(origin: Node2D) -> void:
	bullet_stats.spawn_bullet(origin)
