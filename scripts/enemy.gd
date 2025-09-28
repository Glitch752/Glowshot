extends RigidBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var speed: float = 400

@onready var charging: float = randf()
const CHARGE_TIME: float = 1.0

func _ready() -> void:
    add_to_group("enemy")
    navigation_agent.radius = 100
    navigation_agent.velocity_computed.connect(_move)

    var discrete_nice_hues = [0, 30, 60, 120, 180, 240, 300]
    $Sprite2D.modulate.h = discrete_nice_hues[randi() % discrete_nice_hues.size()] / 360.0

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

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    # Ad-hoc friction
    var friction = pow(0.0001, state.step)
    state.linear_velocity *= friction
    state.angular_velocity *= friction

func _move(velocity: Vector2):
    if charging < CHARGE_TIME:
        charging += get_viewport().get_process_delta_time()
        if charging < 0.1:
            $Sprite2D.scale.y = 5 * (1.3 - ease(charging / 0.1, 1.0) * 0.3)
        else:
            $Sprite2D.scale.y = 5 * (1.0 + ease(charging / CHARGE_TIME, 1.0) * 0.3)
        return
    
    charging = 0

    # move_and_collide(velocity * get_viewport().get_process_delta_time())
    var applied_force = (velocity - linear_velocity) * mass * 1.5
    apply_central_impulse(applied_force.normalized() * min((applied_force.length_squared()) / 100, 3000))




func _on_area_2d_area_entered(area: Area2D) -> void:
    print(area)
    if area.is_in_group("player"):
        GameLoopManager.take_damage(0.1)
