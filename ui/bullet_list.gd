extends HBoxContainer

const BulletListItem = preload("res://ui/bulletListItem.tscn")

func _ready():
    GameLoopManager.max_bullets_changed.connect(_update_full)
    GameLoopManager.bullets_changed.connect(_update)
    
    _update_full(GameLoopManager.max_bullets)
    _update(GameLoopManager.bullets_held)

func _update_full(bullets: int):
    var children = get_child_count()
    if children > bullets:
        for i in range(children - bullets):
            get_child(children - i - 1).queue_free()
    elif children < bullets:
        for i in range(bullets - children):
            var b = BulletListItem.instantiate()
            add_child(b)

func _update(active: int):
    for i in get_child_count():
        get_child(i).active = active > i
