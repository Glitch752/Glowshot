extends TransformContainer

var selected = false

func _ready():
    visible = false
    modulate.a = 0.0
    visual_position = Vector2(0, -20.0)
    
    GameLoopManager.end_wave.connect(_show)

func _show():
    selected = false
    visible = true

    $%CompleteLabel.text = "Wave %d complete!" % GameLoopManager.wave

    $%BrightnessUpgrade.text = "Upgrade brightness\nCurrently level %d" % GameLoopManager.brightness_upgrade_level
    $%DamageUpgrade.text = "Upgrade damage\nCurrently level %d" % GameLoopManager.damage_upgrade_level
    $%BulletsUpgrade.text = "Upgrade max bullets\nCurrently level %d" % GameLoopManager.max_bullets_upgrade_level

    $%BulletsUpgrade.visible = GameLoopManager.wave % 3 == 0

    AudioManager.play_sound(preload("res://audio/whoosh1.wav"))

    var t = create_tween()
    t.tween_property(self, "modulate:a", 1.0, 0.25).from_current()
    t.parallel().tween_property(self, "visual_position:y", 0.0, 0.25).from_current()

    GameLoopManager.end_wave_menu_open = true

func close():
    AudioManager.play_sound(preload("res://audio/whoosh2.wav"))

    var t = create_tween()
    t.tween_property(self, "modulate:a", 0.0, 0.25).from_current()
    t.parallel().tween_property(self, "visual_position:y", -20.0, 0.25).from_current()
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


func _on_bullets_upgrade_pressed() -> void:
    if selected:
        return
    selected = true

    GameLoopManager.max_bullets_upgrade_level += 1
    GameLoopManager.bullets_held += 1 # or else you can't get it back lol
    close()
