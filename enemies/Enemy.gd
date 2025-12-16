extends Area2D

@export var stats: EnemyStats

func _ready() -> void:
	$Sprite2D.texture = stats.texture

func _on_area_entered(bullet: Bullet) -> void:
	if bullet == null:
		return
	print("i hit")
	die()

func die():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	$DeathParticles.emitting = true
	$Sprite2D.visible = false
	await $DeathParticles.finished
	queue_free()
