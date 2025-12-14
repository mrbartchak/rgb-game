extends Sprite2D

@export var color_modes: Array[ColorMode]
var current_mode: ColorMode
#refactor later
var movement_speed: float = 10.5
var is_firing: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	current_mode = color_modes.pick_random()
	self.texture = current_mode.texture
	$AttackTimer.wait_time = 1.0 / current_mode.base_attack.fire_rate
	$AttackTimer.start()

func _physics_process(delta):
	global_position = global_position.lerp(get_viewport().get_mouse_position(), movement_speed * delta)
	_handle_shadow()

#---Attacking---
func _use_attack() -> void:
	current_mode.base_attack.fire($BulletSpawn)

func _on_attack_timer_timeout() -> void:
	_use_attack()

#---Visuals---
func _handle_shadow() -> void:
	var max_offset_shadow: float = 5.0
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	$Shadow.position.x = lerp(0.0, -sign(distance) * max_offset_shadow, abs(distance/center.x))
