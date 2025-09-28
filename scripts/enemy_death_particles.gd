extends Node2D

func _ready():
    $GPUParticles2D.process_material = $GPUParticles2D.process_material.duplicate()
    
    $GPUParticles2D.finished.connect(queue_free)
    $GPUParticles2D.restart()

@export var color: Color:
    set(val):
        color = val
        ($GPUParticles2D.process_material as ParticleProcessMaterial).color = val
