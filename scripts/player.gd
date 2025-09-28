extends CharacterBody2D

@export var speed = 900
@export var acceleration = 6000

@onready var active_light: PointLight2D = $ActiveLightPoint

var was_pressed = false
const GUN_DISTANCE = 100
const RECOIL_AMOUNT = 500

const BULLET = preload("res://bullet.tscn")

func _ready() -> void:
    add_to_group("player_body")

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
        if collider is TileMapLayer and velocity.length() > speed:
            velocity = velocity.normalized() * speed
        
        if collider is RigidBody2D:
            # Ensure the collider is forced outside of us immediately since we take priority
            var impulse = collision.get_depth() * collision.get_normal() * -1 * 10
            if impulse.length_squared() > 36:
                impulse = impulse.normalized() * 6
            collider.apply_impulse(impulse, collision.get_position() - collider.global_position)
            collider.apply_force(collision.get_normal() * velocity.length() * -30, collision.get_position() - collider.global_position)

    GameLoopManager.player_pos = global_position

    var mp = get_global_mouse_position() - global_position
    rotation = atan2(mp.y, mp.x)

    scale.y = -1 if mp.x <= 0 else 1

    active_light.intensity = GameLoopManager.bullets_held
    active_light.visible = GameLoopManager.bullets_held > 0

    var pressed = Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT)
    if pressed and not was_pressed:
        var bullet_direction = Vector2.RIGHT.rotated(rotation)
        var bullet_origin = global_position + bullet_direction * GUN_DISTANCE
        
        var tilemap: TileMapLayer = get_tree().current_scene.get_node("%WallLayer")
        if GameLoopManager.bullets_held == 0 or tilemap.filled_at_position(bullet_origin):
            # TODO: Play "no bullet" click sound
            pass
        else:
            # Fire a bullet
            GameLoopManager.bullets_held -= 1

            var bullet: RigidBody2D = BULLET.instantiate()
            bullet.global_position = bullet_origin
            bullet.rotation = rotation
            bullet.linear_velocity = bullet_direction * 3000

            get_tree().current_scene.add_child(bullet)

            # Apply backward impulse
            velocity -= bullet_direction * RECOIL_AMOUNT
    
    was_pressed = pressed
