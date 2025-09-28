extends RigidBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var speed: float = 400

func _ready() -> void:
    add_to_group("enemy")
    navigation_agent.radius = 100
    navigation_agent.velocity_computed.connect(_move)

func kill():
    queue_free()

func _physics_process(delta: float) -> void:
    navigation_agent.target_position = GameLoopManager.player_pos

    if navigation_agent.is_navigation_finished():
        return
    
    var next_position = navigation_agent.get_next_path_position()
    var direction = (next_position - global_position).normalized()
    var target_velocity = direction * speed
    navigation_agent.velocity = target_velocity
    
    preload("res://scripts/anti_wall_stuck.gd").anti_stuck(self, delta)

func _move(velocity: Vector2):
    # move_and_collide(velocity * get_viewport().get_process_delta_time())
    var applied_force = (velocity - linear_velocity) * mass * 10
    apply_central_force(applied_force)
