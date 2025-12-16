extends Sprite2D

@export var color_modes: Array[ColorMode]
var current_mode: ColorMode
var current_mode_idx: int
#refactor later
var movement_speed: float = 2.5
var is_firing: bool = false

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	set_color_mode(0)
	self.texture = current_mode.texture
	$AttackTimer.wait_time = 1.0 / current_mode.base_attack.fire_rate
	$AttackTimer.start()

func _physics_process(delta):
	_use_mouse_based_movement(delta)
	_handle_shadow()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		set_color_mode((current_mode_idx + 1) % 3)

#---Attacking---
func _use_attack() -> void:
	current_mode.base_attack.fire($BulletSpawn)

func _on_attack_timer_timeout() -> void:
	_use_attack()

#---Color Switching---
func set_color_mode(mode_idx: int) -> void:
	current_mode_idx = mode_idx
	current_mode = color_modes.get(mode_idx)
	self.texture = current_mode.texture
	$AttackTimer.wait_time = 1.0 / current_mode.base_attack.fire_rate

#---Movement---
func _use_mouse_based_movement(delta: float) -> void:
	global_position = global_position.lerp(get_viewport().get_mouse_position(), movement_speed * delta)

#---Visuals---
func _handle_shadow() -> void:
	var max_offset_shadow: float = 5.0
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	$Shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/center.x))
