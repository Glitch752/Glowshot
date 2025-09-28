extends ProgressBar


func _process(delta: float) -> void:
    value = lerp(value, GameLoopManager.health, 5 * delta)
