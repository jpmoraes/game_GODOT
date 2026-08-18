extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.003
@export var jump_velocity: float = 4.5
@export var rotation_speed: float = 3.0
var look_direction : Vector2
const GRAVITY = 9.8
var morreu := false

@export var bullet_scene: PackedScene
@onready var bullet_spawn = $Character_Gun/CharacterArmature/MakeBullet

@onready var spring_arm = $SpringArm3D

@onready var animator = get_node("Character_Gun/AnimationPlayer") as AnimationPlayer

var camera_rotation_x := 0.0

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	
	
	if event is InputEventMouseMotion:
		# Rotação do personagem
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Rotação da câmera
		camera_rotation_x -= event.relative.y * mouse_sensitivity
		camera_rotation_x = clamp(camera_rotation_x, 
								deg_to_rad(-80), 
									deg_to_rad(80))
		spring_arm.rotation.x = camera_rotation_x

	if event.is_action_pressed("uicancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("uireturn"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	if morreu:
		return

	# Gravidade
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
			
		# Movimento
	var input_dir = Vector2.ZERO
	if is_on_floor():
		
		if Input.is_action_pressed("move_forward"):
			input_dir.y += 10
			animator.play("Run")

		elif Input.is_action_pressed("move_back"):
			input_dir.y -= 1
			animator.play("Run")
			
		elif Input.is_action_pressed("move_walk"):
			input_dir.y += 1
			animator.play("Walk")
		else:
			animator.play("Idle")

		if Input.is_action_pressed("move_left"):
			animator.play("Run")
			#malha.rotate_y(rotation_speed * delta)
			input_dir.x += 1
		elif Input.is_action_pressed("move_right"):
			animator.play("Run")
			#malha.rotate_y(-rotation_speed * delta)
			input_dir.x -= 1
		
		input_dir = input_dir.normalized()

		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	else:
		animator.play("Jump",0.6)
	
	if Input.is_action_just_pressed("shoot") and animator.current_animation == "Idle":
		shoot()
	elif Input.is_action_pressed("shoot") and animator.current_animation == "Run":
		animator.play("Run_Shoot")
	elif Input.is_action_pressed("shoot") and animator.current_animation == "Walk":
		animator.play("Walk_Shoot")			
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.is_in_group("enemy"):
			morreu=true			
			velocity = Vector3.ZERO
			animator.play("Death", 0.6)
			
			await animator.animation_finished
			
			await get_tree().create_timer(3.0).timeout
			get_tree().reload_current_scene()

func shoot():
	if animator.current_animation != "Idle":
		return

	animator.play("Idle_Shoot")
	

	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = bullet_spawn.global_position
	bullet.direction = -bullet_spawn.global_transform.basis.z.normalized()
