extends CanvasLayer

var transitioning = false

func _ready() -> void:
    var lowPass: AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
    lowPass.cutoff_hz = 2500
    transitioning = false

func _on_play_button_pressed() -> void:
    if transitioning:
        return
    transitioning = true

    SceneTransitions.transition_to_level()
