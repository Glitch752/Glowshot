extends CanvasLayer

func _ready():
    $%Description.text = "Survived %d waves" % (GameLoopManager.wave - 1)
    
    $CanvasModulate.color.a = 0
    
    var lowPass: AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
    
    var t = create_tween()
    t.set_ignore_time_scale(true)
    t.tween_property($CanvasModulate, "color:a", 1.0, 1.0)
    t.parallel().tween_property(Engine, "time_scale", 0.1, 1.0)
    t.parallel().tween_property(lowPass, "cutoff_hz", 1800, 1.0)

func _on_restart_button_pressed() -> void:
    var lowPass: AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)

    var t = create_tween()
    t.set_ignore_time_scale(true)
    t.tween_property($CanvasModulate, "color:a", 0.0, 1.0)
    t.parallel().tween_property(Engine, "time_scale", 1.0, 1.0)
    t.parallel().tween_property(lowPass, "cutoff_hz", 20500, 1.0)
    t.tween_callback(func():
        get_tree().reload_current_scene()
        queue_free()
    )
