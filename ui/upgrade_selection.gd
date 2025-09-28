extends TransformContainer

var selected = false

func _ready():
    visible = false
    modulate.a = 0.0
    visual_position = Vector2(0, -20.0)
    
    GameLoopManager.end_wave.connect(_show)

func _show():
    selected = false

    $%BrightnessUpgrade.text = "Upgrade brightness\nCurrently level %d" % GameLoopManager.brightness_upgrade_level
    $%DamageUpgrade.text = "Upgrade damage\nCurrently level %d" % GameLoopManager.damage_upgrade_level

    var t = create_tween()
    t.set_ease(Tween.EASE_IN_OUT)
    t.set_trans(Tween.TRANS_CUBIC)
    t.set_ignore_time_scale(true)

    visible = true
    t.tween_property(self, "modulate:a", 1.0, 0.15)
    t.parallel().tween_property(self, "visual_position:y", 0.0, 0.15)

    GameLoopManager.end_wave_menu_open = true

func close():
    var t = create_tween()
    t.set_ease(Tween.EASE_IN_OUT)
    t.set_trans(Tween.TRANS_CUBIC)
    t.set_ignore_time_scale(true)

    t.tween_property(self, "modulate:a", 0.0, 0.15)
    t.parallel().tween_property(self, "visual_position:y", -20.0, 0.15)
    t.tween_callback(func():
        visible = false
        GameLoopManager.end_wave_menu_open = false
        GameLoopManager.begin_wave()
    )


func _on_brightness_upgrade_pressed() -> void:
    if selected:
        return
    selected = true

    GameLoopManager.brightness_upgrade_level += 1
    close()

func _on_damage_upgrade_pressed() -> void:
    if selected:
        return
    selected = true

    GameLoopManager.damage_upgrade_level += 1
    close()
