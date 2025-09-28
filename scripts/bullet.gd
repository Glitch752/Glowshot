extends RigidBody2D

@onready var spawn_time = Time.get_ticks_msec()

func can_kill() -> bool:
    return linear_velocity.length() > 300

func _physics_process(delta: float):
    preload("res://scripts/anti_wall_stuck.gd").anti_stuck(self, delta)
    set_collision_layer_value(0, !can_kill())

func _on_pickup_radius_area_entered(body: Node2D) -> void:
    if Time.get_ticks_msec() - spawn_time < 250:
        return # Small cooldown to prevent immediate pickup
    
    if body.is_in_group("player"):
        body.pick_up_bullet(self)


func _ready():
    $Area2D.area_entered.connect(_on_enter_whatev)

func _on_enter_whatev(area: Area2D) -> void:
    var body = area.get_parent()
    if body is RigidBody2D:
        if body.is_in_group("enemy") and can_kill():
            body.kill()
