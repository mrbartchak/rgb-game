extends Node2D

@export var enemy_types: Array[EnemyStats]
@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.5

var screen_size: Vector2
var rows: int = 3
var cols: int = 8
var spacing: Vector2 = Vector2(12, 10)
var start_pos: Vector2 = Vector2(120, 10)

func _ready() -> void:
	screen_size = get_viewport_rect().size
	call_deferred("spawn_grid")

func spawn_grid():
	for row in range(rows):
		for col in range(cols):
			var pos_x = start_pos.x + col * spacing.x
			var pos_y = start_pos.y + row * spacing.y
			spawn_enemy(Vector2(pos_x, pos_y))
			#enemy.global_position = Vector2(randf_range(0, screen_size.x), 50)

func spawn_enemy(spawn_at: Vector2):
	var enemy = enemy_scene.instantiate()
	enemy.stats = enemy_types.pick_random()
	get_parent().add_child(enemy)
	enemy.global_position = spawn_at
