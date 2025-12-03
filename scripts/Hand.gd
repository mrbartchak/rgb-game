extends Sprite2D

@export var hand_stats: Array[HandStats]
@export var bullet_scene: PackedScene
var current_bullet: BulletStats
var movement_speed: float = 10.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var current_hand = hand_stats.pick_random()
	texture = current_hand.texture
	current_bullet = current_hand.bullet_type

func _physics_process(delta):
	global_position = global_position.lerp(get_viewport().get_mouse_position(), movement_speed * delta)
	look_at(Vector2(get_viewport_rect().size.x /2, -120))
	self.rotation_degrees += 90

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot_bullet()

func shoot_bullet():
	$BulletSound.pitch_scale = randf_range(0.8, 1.2)
	$BulletSound.play()
	var bullet: Node2D = bullet_scene.instantiate()
	bullet.bullet_stats = current_bullet
	bullet.position = $BulletSpawn.global_position
	bullet.rotation = rotation
	bullet.show_behind_parent = true
	get_parent().add_child(bullet)
