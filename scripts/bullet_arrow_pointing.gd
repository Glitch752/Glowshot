extends CanvasLayer

## Arrow textures, in clockwise order, starting from rightward
@export var arrowTextures: Array[Texture2D] = []

@onready var texture: TextureRect = $TextureRect
@onready var bullet: Node2D = $".."

func _process(_delta: float) -> void:
    var camera_world_pos = get_viewport().get_camera_2d().global_position
    var diff = bullet.global_position - camera_world_pos
    if diff.length() < 300:
        texture.visible = false
        return
    
    var dir = diff.normalized()
    # Project to the outside of the canvas layer
    var view_rect = get_viewport().get_visible_rect().size
    var screen_pos = view_rect * 0.5 + dir * (view_rect * 0.5).length()
    texture.position = screen_pos.clamp(texture.size, view_rect - texture.size)