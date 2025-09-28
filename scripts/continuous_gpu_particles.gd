extends GPUParticles2D

## Makes a gpu particle emitter spawn a "continuous trail" by updating its
## emitter bounds to span the area from its previous position to current every frame.

var last_position: Vector2 = Vector2.ZERO
var first_frame: bool = true

@export var emission_width: int = 2

func _ready() -> void:
    process_material = process_material.duplicate()

func _physics_process(_delta: float) -> void:
    if first_frame:
        last_position = global_position
        first_frame = false
    
    var dpos = global_position - last_position

    amount_ratio = min(1, dpos.length() / 10.0)
    
    var mat: ParticleProcessMaterial = process_material
    mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
    # Rotate the whole emitter to be aligned with the direction of travel
    global_rotation = dpos.angle()
    # Set the emission box to be a thin rectangle spanning from last to current position
    mat.emission_box_extents = Vector3(dpos.length() * 0.5 + 1, emission_width, 1)
    # Offset the box so that its center is halfway between last and
    # current position
    mat.emission_shape_offset = Vector3(dpos.x * 0.5, dpos.y * 0.5, 0)

    last_position = global_position
