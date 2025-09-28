extends Node

var player_pos: Vector2 = Vector2.ZERO

signal bullets_changed(new: int)
signal health_changed(new: float)
signal wave_changed(new: int)

var max_bullets: int = 3
var bullets_held: int = 3:
    set(val):
        bullets_held = val
        bullets_changed.emit(val)

var health: float = 1:
    set(val):
        health = val
        health_changed.emit(val)

var wave: int = 1:
    set(val):
        wave = val
        wave_changed.emit(val)