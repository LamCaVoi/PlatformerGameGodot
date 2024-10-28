extends PlayerState

var jump_height: float = 1
var prevVelocity = Vector2.ZERO
var start_gravity = 0
var start_velocity = 0 

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("jump") and player.velocity.y < -150:
		player.velocity.y *= player.short_jump_cut
		#player.velocity.y += 100

func update(delta: float) -> void:
	pass
	
func hang_boost():
	if player.velocity.y > -player.hang_threshold and player.velocity.y < 0:
		player.jump_gravity *= 0.95
		player.max_x_speed += 10
	else:
		player.jump_gravity = start_gravity
		player.max_x_speed = start_velocity

func physics_update(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	player.run(direction)
	player.apply_gravity(delta)
	hang_boost()
	player.velocity.x = lerp(prevVelocity.x, player.velocity.x, player.velocity_x_lerp_speed)
	player.move_and_slide()
	prevVelocity = player.velocity
	switch_state()

func switch_state():
	if player.velocity.y > 0:
		finished.emit("Fall")

func enter(previous_state_path: String, data := {}) -> void:
	start_gravity = player.jump_gravity
	start_velocity = player.max_x_speed
	prevVelocity = player.velocity
	player.velocity.y = player.high_jump_velocity
	player.animated_sprite.play("jump")

func exit() -> void:
	player.max_x_speed = start_velocity
	player.jump_gravity = start_gravity
