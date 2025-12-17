extends CharacterBody2D

@export var chromas: Array[ChromaStats]
var current_chroma: ChromaStats
var current_mode_idx: int
#refactor later
var movement_speed: float = 100.0
var is_firing: bool = false

func _ready() -> void:
	set_color_mode(0)
	$Skin.texture = current_chroma.texture
	$MuzzleFlash.modulate = current_chroma.color
	$AttackTimer.wait_time = 1.0 / current_chroma.base_attack.fire_rate
	$AttackTimer.start()

func _physics_process(delta):
	_handle_movement(delta)
	_aim_at_cursor()
	#_use_mouse_based_movement(delta)
	_handle_shadow()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		set_color_mode((current_mode_idx + 1) % 3)

#---Attacking---
func _use_attack() -> void:
	_flash_muzzle()
	current_chroma.base_attack.fire($BulletSpawn)

func _on_attack_timer_timeout() -> void:
	_use_attack()

#---Color Switching---
func set_color_mode(mode_idx: int) -> void:
	current_mode_idx = mode_idx
	current_chroma = chromas.get(mode_idx)
	$Skin.texture = current_chroma.texture
	$MuzzleFlash.modulate = current_chroma.color
	$AttackTimer.wait_time = 1.0 / current_chroma.base_attack.fire_rate

#---Movement---
func _handle_movement(delta: float) -> void:
	var accel: float = 1800.0
	var friction: float = 2600.0
	var input_dir: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	if input_dir!= Vector2.ZERO:
		velocity = velocity.move_toward(
			input_dir * movement_speed,
			accel * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			friction * delta
		)
	move_and_slide()

func _aim_at_cursor() -> void:
	var dir = get_global_mouse_position() - global_position
	rotation = dir.angle() + PI / 2

func _use_mouse_based_movement(delta: float) -> void:
	global_position = global_position.lerp(get_viewport().get_mouse_position(), movement_speed * delta)

#---Visuals---
func _handle_shadow() -> void:
	var max_offset_shadow: float = 5.0
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	$Shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/center.x))

func _flash_muzzle() -> void:
	$MuzzleFlash.visible = true
	await get_tree().create_timer(0.1).timeout
	$MuzzleFlash.visible = false
