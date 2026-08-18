extends Area3D

@export var speed := 50.0

var direction := Vector3.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta):
	global_position -= direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.die()
		queue_free()
