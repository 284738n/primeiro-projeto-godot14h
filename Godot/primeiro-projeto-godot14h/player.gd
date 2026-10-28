extends CharacterBody2D

const SPEED = 250
const JUMP_FORCE = -350

var is_jumping := false

@onready var animation := $anim as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Aplicar a gravidade.
	if not is_on_floor():
		velocity += get_gravity() * delta
		

	# Tratar o pulo.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Atualizar o estado de pulo com base no contato com o chão
	is_jumping = not is_on_floor()

	# Ler a direção de entrada e tratar movimento/desaceleração.
	# Como boa prática, substitua ações de UI por ações específicas do jogo.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		# Manter a animação de corrida enquanto move horizontalmente, mesmo no ar
		animation.play("run")
	else:
		# Aplicar desaceleração horizontal mesmo durante o pulo
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_jumping:
			animation.play("jump")
		else:
			animation.play("idle")

	move_and_slide() 
