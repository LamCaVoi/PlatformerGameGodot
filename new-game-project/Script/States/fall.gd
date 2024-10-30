extends PlayerState

var coyote_timer: float = 0
var buffer_jump_timer: float = 0
var prevVelocity:= Vector2.ZERO
var start_gravity = 0
var start_velocity = 0
var was_jumping = false

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		if coyote_timer >= 0:
			finished.emit("Jump")
		else:
			buffer_jump_timer = player.buffer_jump_time
	elif Input.is_action_just_pressed("dash"):
		finished.emit("Dash")

func update(delta: float) -> void:
	pass
	
func timer_update(delta):
	if coyote_timer > 0:
		coyote_timer -= delta
	if buffer_jump_timer > 0:
		buffer_jump_timer -= delta

func hang_boost():
	if player.velocity.y < player.hang_threshold and was_jumping:
		player.fall_gravity *= 0.95
		player.max_x_speed += 10
	else: 
		player.fall_gravity = start_gravity
		player.max_x_speed = start_velocity
	
func physics_update(delta: float) -> void:
	timer_update(delta)
	var direction := Input.get_axis("move_left", "move_right")
	player.run(direction)
	player.apply_gravity(delta)
	hang_boost()
	player.velocity.x = lerp(prevVelocity.x, player.velocity.x, player.velocity_x_lerp_speed)
	player.velocity.y = lerp(prevVelocity.y, player.velocity.y, player.velocity_y_lerp_speed)
	player.move_and_slide()
	prevVelocity = player.velocity
	switch_state(direction)

func switch_state(direction):
	if player.is_on_floor():
		if buffer_jump_timer > 0:
			buffer_jump_timer = -1
			finished.emit("Jump")
		elif is_equal_approx(direction, 0.0):
			finished.emit("Idle")
		else:
			finished.emit("Run")

func enter(previous_state_path: String, data := {}) -> void:
	start_gravity = player.fall_gravity
	start_velocity = player.max_x_speed
	prevVelocity = player.velocity
	player.animated_sprite.play("fall")
	if(previous_state_path != "Jump"):
		coyote_timer = player.coyote_time
	else: 
		was_jumping = true
		coyote_timer = -1

func exit() -> void:
	pass
