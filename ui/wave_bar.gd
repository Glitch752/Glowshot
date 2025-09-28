extends ProgressBar

func _ready():
    _update(GameLoopManager.wave)
    GameLoopManager.wave_changed.connect(_update)

func _update(new: float):
    value = new
