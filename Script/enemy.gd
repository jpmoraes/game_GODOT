extends CharacterBody3D

@export var velocidade := 3.0
@export var distancia_perseguicao := 8.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var navigation_agent = $NavigationAgent3D
@onready var animator = get_node("Crab2/AnimationPlayer") as AnimationPlayer
var is_dead := false

func _ready():
	add_to_group("enemy")
	$Crab2.rotation_degrees.y = 180

func _physics_process(delta):

	if player == null:
		return

	var distancia = global_position.distance_to(player.global_position)

	if distancia <= distancia_perseguicao:
		perseguir_player()
	else:
		velocity = Vector3.ZERO
		move_and_slide()
		
				
		
func perseguir_player():

	navigation_agent.target_position = player.global_position

	var proxima_posicao = navigation_agent.get_next_path_position()

	var direcao = global_position.direction_to(proxima_posicao)

	velocity = direcao * velocidade	
	animator.play("Walk")
	move_and_slide()

	look_at(
		Vector3(
			player.global_position.x,
			global_position.y,
			player.global_position.z
		),
		Vector3.UP
	)

func die():

	if is_dead:
		return

	is_dead = true

	velocity = Vector3.ZERO

	print("ok")

	animator.play("Death", 0.6)

	await animator.animation_finished

	queue_free()
