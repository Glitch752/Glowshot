extends RigidBody2D

@onready var spawn_time = Time.get_ticks_msec()

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("enemy") and linear_velocity.length() > 300:
        body.kill()

func _physics_process(delta: float):
    preload("res://scripts/anti_wall_stuck.gd").anti_stuck(self, delta)

func _on_pickup_radius_area_entered(body: Node2D) -> void:
    if Time.get_ticks_msec() - spawn_time < 250:
        return # Small cooldown to prevent immediate pickup
    
    if body.is_in_group("player"):
        body.pick_up_bullet(self)
