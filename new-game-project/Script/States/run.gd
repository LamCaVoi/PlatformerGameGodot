extends PlayerState

var prev_velocity: Vector2= Vector2.ZERO
var start_accel: float = 0.0

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var direction = Input.get_axis("move_left","move_right")
	if direction != 0:
		if direction != sign(player.velocity.x) and player.velocity.x != 0:
			player.velocity.x = move_toward(prev_velocity.x, direction * player.max_x_speed, player.acceleration * delta * 2)
		else:
			player.velocity.x = move_toward(prev_velocity.x, direction * player.max_x_speed, player.acceleration * delta)
		if direction == 1: 
			player.animated_sprite.flip_h = false
		if direction == -1:
			player.animated_sprite.flip_h = true
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * delta)
	player.apply_gravity(delta)
	player.move_and_slide()
	switch_state(direction, delta)
	prev_velocity = player.velocity
	
func switch_state(direction, delta):
	if not player.is_on_floor():
		finished.emit("Fall")
	elif Input.is_action_just_pressed("jump"):
		finished.emit("Jump")
	elif Input.is_action_just_pressed("dash"):
		finished.emit("Dash")
	elif abs(player.velocity.x) < player.friction * delta and direction == 0:
		finished.emit("Idle")

func enter(previous_state_path: String, data := {}) -> void:
	start_accel = player.acceleration
	prev_velocity = player.velocity
	player.animated_sprite.play("run")

func exit() -> void:
	pass
