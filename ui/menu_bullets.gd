extends Node2D

const MenuBullet = preload("res://ui/menu_bullet.tscn")

func _ready():
    var timer = Timer.new()
    timer.wait_time = 0.4
    timer.one_shot = false
    timer.autostart = true
    add_child(timer, false, INTERNAL_MODE_FRONT)

    timer.timeout.connect(_spawn_bullet)

func _spawn_bullet():
    var bullet = MenuBullet.instantiate()
    bullet.global_position = Vector2(-1920.0 / 2, randf() * 1080. * 2.)
    add_child(bullet)

func _process(delta: float) -> void:
    for bullet in get_children():
        if bullet.global_position.x > 1920.0 * 2:
            bullet.queue_free()
        bullet.global_position += delta * Vector2(2800.0, -1600.0)
