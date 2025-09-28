extends Node

func transition_to_level():
    AudioManager.play_sound(preload("res://audio/whoosh2.wav"))
    
    var lowPass: AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
    
    var fade = ColorRect.new()
    fade.color = Color.BLACK
    fade.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_FULL_RECT)
    fade.modulate.a = 0

    var fade_layer = CanvasLayer.new()
    fade_layer.add_child(fade)
    fade_layer.layer = 100
    get_tree().root.add_child(fade_layer)

    var t = create_tween()
    t.set_ease(Tween.EASE_IN_OUT)
    t.set_trans(Tween.TRANS_CUBIC)

    t.tween_property(fade, "modulate:a", 1, 0.5)
    t.parallel().tween_property(lowPass, "cutoff_hz", 20500, 0.5)
    
    t.tween_callback(func():
        get_tree().change_scene_to_packed(preload("res://level.tscn"))
    )

    t.tween_property(fade, "modulate:a", 0, 0.5)
    
    t.tween_callback(fade.queue_free)


func reload_level():
    var fade = ColorRect.new()
    fade.color = Color.BLACK
    fade.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_FULL_RECT)
    fade.modulate.a = 0

    var fade_layer = CanvasLayer.new()
    fade_layer.add_child(fade)
    fade_layer.layer = 100
    get_tree().root.add_child(fade_layer)

    var t = create_tween()
    t.set_ease(Tween.EASE_IN_OUT)
    t.set_trans(Tween.TRANS_CUBIC)

    t.tween_property(fade, "modulate:a", 1, 0.5)
    
    t.tween_callback(func():
        get_tree().reload_current_scene()
    )

    t.tween_property(fade, "modulate:a", 0, 0.5)
    
    t.tween_callback(fade.queue_free)
