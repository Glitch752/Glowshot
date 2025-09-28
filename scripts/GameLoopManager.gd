extends Node

var player_pos: Vector2 = Vector2.ZERO

signal bullets_changed(new: int)

var max_bullets: int = 3
var bullets_held: int = 3:
    set(val):
        bullets_held = val
        bullets_changed.emit(val)
