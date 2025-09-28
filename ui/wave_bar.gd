extends VBoxContainer

func _ready():
    _update(GameLoopManager.wave)
    GameLoopManager.wave_changed.connect(_update)
    GameLoopManager.enemies_remaining_changed.connect(_update_enemies)

func _update(new: float):
    $WaveBar.max_value = GameLoopManager.wave_enemies_total
    $%CurrentWave.text = "Wave %d" % new

func _update_enemies(enemies: float):
    var t = create_tween()
    t.tween_property($WaveBar, "value", enemies, 0.25)
    
    $%RemainingEnemies.text = "%d enemies remain" % enemies
