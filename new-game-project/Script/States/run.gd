extends PlayerState

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var direction = Input.get_axis("move_left","move_right")
	if direction != 0:
		player.velocity.x += direction * player.acceleration * delta
		if direction == 1: 
			player.animated_sprite.flip_h = false
		if direction == -1:
			player.animated_sprite.flip_h = true
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * delta)
	player.velocity.x = clamp(player.velocity.x, -player.max_x_speed, player.max_x_speed)
	player.apply_gravity(delta)
	player.move_and_slide()
	switch_state(direction, delta)
	
func switch_state(direction, delta):
	if not player.is_on_floor():
		finished.emit("Fall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif abs(player.velocity.x) < player.friction * delta:
		finished.emit("Idle")

func enter(previous_state_path: String, data := {}) -> void:
	player.animated_sprite.play("run")

func exit() -> void:
	pass
