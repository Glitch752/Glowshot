@tool

extends TextureRect

@export var active_texture: Texture2D
@export var inactive_texture: Texture2D

@export var active: bool = false:
    set(val):
        texture = active_texture if val else inactive_texture

func _ready():
    texture = active_texture if active else inactive_texture
