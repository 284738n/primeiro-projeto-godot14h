extends Area2D
@export var achievements_name: String = "Eu vou ser o rei dos piratas!"
func _on_body_entered(body: Node2D) -> void:
	queue_free()

func achievements_generator(player: String, achievements:String) -> void:
	print("jogador ", player, "recebeu a conquista:",achievements)
