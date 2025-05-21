extends CharacterBody3D

var speed = 5.0
var sprint_speed = 8.0
var gravity = 9.8
var mouse_sensitivity = 0.002
var flashlight_on = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$eye/light.light_energy = 0.0  # Flashlight off initially

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Movement
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_axis("idathu", "valathu")
	input_dir.z = Input.get_axis("munnadi", "pinnadi")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()
	if Input.is_action_pressed("sprint"):
		velocity.x = direction.x * sprint_speed
		velocity.z = direction.z * sprint_speed
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	move_and_slide()

	# Flashlight toggle
	if Input.is_action_just_pressed("flashlight"):
		flashlight_on = !flashlight_on
		$eye/light.light_energy = 10 if flashlight_on else 0.0

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		var collider = $eye/hand.get_collider()
		if collider and collider.is_in_group("interactable"):
			print("Interacted with: ", collider.name)  # For testing

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$eye.rotate_x(-event.relative.y * mouse_sensitivity)
		$eye.rotation.x = clamp($eye.rotation.x, -1.5, 1.5)

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
