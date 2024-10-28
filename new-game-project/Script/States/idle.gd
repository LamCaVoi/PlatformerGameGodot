extends PlayerState

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	player.move_and_slide()
	switch_state()

func switch_state():
	#Fall
	if player.velocity.y > 0: 
		finished.emit("Fall")
	#Jump
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	#Run
	else:
		var direction = Input.get_axis("move_left", "move_right")
		if direction != 0:
			finished.emit("Run")
	

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.animated_sprite.play("idle")

func exit() -> void:
	pass