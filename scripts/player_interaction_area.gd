extends Area2D

func _ready() -> void:
    add_to_group("player")

func pick_up_bullet(bullet: Node2D):
    bullet.remove()
    GameLoopManager.bullets_held += 1
    # TODO: Sound and other juice
