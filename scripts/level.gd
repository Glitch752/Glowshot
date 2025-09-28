extends Node2D

@export var nav_region: NavigationRegion2D

const ENEMY = preload("res://enemy.tscn")

func _ready():
    GameLoopManager.spawn_enemy.connect(spawn_enemy)
    
    GameLoopManager.reset()

func spawn_enemy():
    # Pick random points within the nav region until we find one that isn't on screen

    # The boundaries of the camera in global coordinates
    var camera_transform = get_viewport().get_camera_2d().global_transform

    var scr_size = get_viewport().get_visible_rect().size
    # We intentionally don't use the camera transform's basis vectors since its rotation is locked
    var min_pos = camera_transform.origin - Vector2.RIGHT * scr_size.x * 0.5 - Vector2.DOWN * scr_size.y * 0.5
    var max_pos = camera_transform.origin + Vector2.RIGHT * scr_size.x * 0.5 + Vector2.DOWN * scr_size.y * 0.5
    var view_size = max_pos - min_pos
    var view_rect = Rect2(min_pos, view_size)
    
    var spawn_pos = Vector2.ZERO
    for _i in 8:
        spawn_pos = NavigationServer2D.region_get_random_point(nav_region.get_rid(), 1, false)
        if not view_rect.has_point(spawn_pos):
            break
    
    var enemy = ENEMY.instantiate()
    enemy.global_position = spawn_pos
    enemy.max_health = GameLoopManager.wave_enemy_health
    enemy.health = GameLoopManager.wave_enemy_health
    add_child(enemy)
