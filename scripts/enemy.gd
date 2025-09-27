extends RigidBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
    add_to_group("enemy")

func kill():
    queue_free()

func _physics_process(delta: float) -> void:
    navigation_agent.target_position = GameLoopManager.player_pos

    if navigation_agent.is_navigation_finished():
        return
    
    var next_position = navigation_agent.get_next_path_position()
    var direction = (next_position - global_position).normalized()
    var target_velocity = direction * 500

    move_and_collide(target_velocity * 1 * delta)
