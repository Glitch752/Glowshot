extends RigidBody2D


func _on_body_entered(body: Node) -> void:
    if body.is_in_group("enemy"):
        body.kill()

func _physics_process(delta: float):
    preload("res://scripts/anti_wall_stuck.gd").anti_stuck(self, delta)
