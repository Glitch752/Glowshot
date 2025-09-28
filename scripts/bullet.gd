extends RigidBody2D

@onready var spawn_time = Time.get_ticks_msec()

func can_kill() -> bool:
    return linear_velocity.length() > 300

func _physics_process(delta: float):
    preload("res://scripts/anti_wall_stuck.gd").anti_stuck(self, delta)
    set_collision_layer_value(1, !can_kill())

func _on_pickup_radius_area_entered(body: Node2D) -> void:
    if Time.get_ticks_msec() - spawn_time < 250:
        return # Small cooldown to prevent immediate pickup
    
    if body.is_in_group("player"):
        body.pick_up_bullet(self)

func remove():
    # Move the particle system to the top leve of the scene at our current position so it continues after we're removed
    # Then, turn off spawning new particles and remove it after a full loop is completed.
    var particles: GPUParticles2D = $GPUParticles2D
    particles.reparent(get_tree().current_scene)

    # Not sure why particles.finished doesn't fire but whatever this works
    var t = Timer.new()
    t.one_shot = true
    t.wait_time = particles.lifetime
    t.timeout.connect(func():
        particles.queue_free()
        t.queue_free()
    )
    get_tree().current_scene.add_child(t)
    t.start()

    particles.one_shot = true
    particles.show_behind_parent = false

    queue_free()

func _ready():
    $Area2D.area_entered.connect(_on_enter_whatev)

func _on_enter_whatev(area: Area2D) -> void:
    var body = area.get_parent()
    if body is RigidBody2D:
        if body.is_in_group("enemy") and can_kill():
            body.hit()
