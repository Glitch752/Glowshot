extends RigidBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var speed: float = 300

func _ready() -> void:
    add_to_group("enemy")
    navigation_agent.radius = 100

func kill():
    queue_free()

func _physics_process(delta: float) -> void:
    navigation_agent.target_position = GameLoopManager.player_pos

    if navigation_agent.is_navigation_finished():
        return
    
    var next_position = navigation_agent.get_next_path_position()
    var direction = (next_position - global_position).normalized()
    var target_velocity = direction * speed

    move_and_collide(target_velocity * 1 * delta)
    
    preload("res://scripts/anti_wall_stuck.gd").anti_stuck(self, delta)

    queue_redraw()

func _draw():
    draw_line(Vector2(0, 0), navigation_agent.get_next_path_position() - global_position, Color.GREEN, 5)
