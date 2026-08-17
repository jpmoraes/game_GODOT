extends Control

@onready var label_pontuacao = $PontuacaoLabel
@onready var label_tempo = $TempoLabel

var pontuacao := 0
var tempo := 0.0

func _process(delta):
	tempo += delta
	
	label_tempo.text = "Tempo: " + formatar_tempo(tempo)


func adicionar_pontos(pontos: int):
	pontuacao += pontos
	label_pontuacao.text = "Moedas: " + str(pontuacao)


func formatar_tempo(segundos: float) -> String:
	var minutos := int(segundos) / 60
	var segundos_restantes := int(segundos) % 60
	var milis := int((segundos - floor(segundos)) * 1000)
	
	
	return "%02d:%02d:%03d" % [minutos, segundos_restantes, milis]
