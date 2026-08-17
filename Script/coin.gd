extends Node3D


# Called when the node enters the scene tree for the first time.
@onready var coin = preload("res://Prefab/coin.tscn")


func _ready():
	for i in range(50): # Cria 10 objetos
		var instancia = coin.instantiate() # Cria o objeto
		
		var x = randf_range(-20.0,20.0)
		var z = randf_range(-20.0,20.0)
		
		instancia.position = Vector3(x, 3, z)
		add_child(instancia) # Adiciona na cena atual
		

		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
