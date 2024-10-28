extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You're death	")
	Engine.time_scale = 0.5
	timer.start()



func _on_timer_timeout() -> void:
	print("Timer ended!!!")
	Engine.time_scale = 1
	get_tree().reload_current_scene()
