extends CanvasLayer

## Arrow textures at 45 degree increments, in clockwise order, starting from rightward
@export var arrowTextures: Array[Texture2D] = []

@onready var texture: TextureRect = $TextureRect
@onready var bullet: Node2D = $".."

func _process(_delta: float) -> void:
    # The boundaries of the camera in global coordinates
    var camera_transform = get_viewport().get_camera_2d().global_transform

    var scr_size = get_viewport().get_visible_rect().size
    # We intentionally don't use the camera transform's basis vectors since its rotation is locked
    var min_pos = camera_transform.origin - Vector2.RIGHT * scr_size.x * 0.5 - Vector2.DOWN * scr_size.y * 0.5
    var max_pos = camera_transform.origin + Vector2.RIGHT * scr_size.x * 0.5 + Vector2.DOWN * scr_size.y * 0.5
    var view_size = max_pos - min_pos
    var view_rect = Rect2(min_pos, view_size)

    # If already on the screen, don't show
    if view_rect.has_point(bullet.global_position):
        texture.visible = false
        return
    
    var camera_world_pos = get_viewport().get_camera_2d().global_position
    var bullet_screen_pos = bullet.global_position - camera_world_pos
    if bullet_screen_pos.length() < 300:
        texture.visible = false
        return
    
    var dir = bullet_screen_pos.normalized()
    # Project to the outside of the canvas layer
    var screen_pos = view_size * 0.5 + dir * (view_size * 0.5).length()

    assert(arrowTextures.size() == 8)

    # Set the texture to the nearest 45 degree implement
    var angle_idx = roundi(dir.angle() / (PI / 4) + 8) % 8
    texture.texture = arrowTextures[angle_idx]
    
    texture.position = screen_pos.clamp(texture.size, view_size - texture.size) - texture.size / 2
    texture.visible = true
