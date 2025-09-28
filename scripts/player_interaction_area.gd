extends Area2D

func _ready() -> void:
    add_to_group("player")

func pick_up_bullet(bullet: Node2D):
    bullet.remove()
    GameLoopManager.bullets_held += 1
    
    AudioManager.play_sound(preload("res://audio/kenney_impact-sounds/impactTin_medium_004.ogg"), -4.0, randf_range(1.0, 1.2))
    # TODO: Sound and other juice
