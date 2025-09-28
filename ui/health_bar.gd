extends ProgressBar

func _ready():
    _update(GameLoopManager.health)
    GameLoopManager.health_changed.connect(_update)

func _update(new: float):
    value = new
