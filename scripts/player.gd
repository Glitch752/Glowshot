extends CharacterBody2D

@export var speed = 900
@export var acceleration = 6000

@onready var active_light: PointLight2D = $ActiveLightPoint

var was_pressed = false

func _physics_process(delta: float) -> void:
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    
    var target_velocity = direction * speed

    # If the current velocity is within 15deg of the target and of a larger magnitude, leave it alone.
    # Allows for silly things like gun boosts.
    if direction != Vector2.ZERO and abs(velocity.angle_to(direction)) < deg_to_rad(15) and velocity.length() > target_velocity.length():
        target_velocity = velocity
    
    var effective_acceleration = acceleration * (direction.length() * 0.75 + 0.25)
    velocity = velocity.move_toward(target_velocity, effective_acceleration * delta)

    move_and_slide()
    for i in get_slide_collision_count():
        var collision = get_slide_collision(i)
        var collider = collision.get_collider()
        if collider is RigidBody2D:
            # Ensure the collider is forced outside of us immediately since we take priority
            collider.apply_impulse(collision.get_depth() * collision.get_normal() * -1 * 10, collision.get_position() - collider.global_position)
            collider.apply_force(collision.get_normal() * velocity.length() * -3, collision.get_position() - collider.global_position)

    GameLoopManager.player_pos = global_position

    var mp = get_global_mouse_position() - global_position
    rotation = atan2(mp.y, mp.x)
    
    #bullet.process_mode = Node.PROCESS_MODE_PAUSABLE if GameLoopManager.has_bullet else Node.PROCESS_MODE_DISABLED
    active_light.visible = GameLoopManager.bullets_held > 0

    var pressed = Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT)
    if pressed and not was_pressed:
        # Fire a bullet
        var bullet_direction = Vector2.RIGHT.rotated(rotation)
        var bullet_origin = global_position + bullet_direction * GUN_DISTANCE

        var bullet: RigidBody2D = BULLET.instantiate()
        bullet.global_position = bullet_origin
        bullet.rotation = rotation
        bullet.linear_velocity = bullet_direction * 2000

        get_tree().current_scene.add_child(bullet)

        # Apply backward impulse
        velocity -= bullet_direction * 1000
    
    was_pressed = pressed

const GUN_DISTANCE = 100
const BULLET = preload("res://bullet.tscn")
