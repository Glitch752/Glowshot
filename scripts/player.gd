extends CharacterBody2D

@export var speed = 700
@export var acceleration = 6000

func _physics_process(delta: float) -> void:
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    
    var target_velocity = direction * speed
    velocity = velocity.move_toward(target_velocity, acceleration * delta)

    move_and_slide()
