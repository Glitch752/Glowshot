extends HBoxContainer

func _ready():
    GameLoopManager.bullets_changed.connect(_update)
    
    _update(GameLoopManager.bullets_held)

func _update(active: int):
    for i in get_child_count():
        get_child(i).active = active > i
