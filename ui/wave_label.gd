@tool
extends TransformContainer

func _ready():
    if not Engine.is_editor_hint():
        visible = false
        modulate.a = 0
        visual_position = Vector2(0, -50)
        
        GameLoopManager.wave_changed.connect(_show_new_wave)

func _show_new_wave(wave: int):
    $Label.text = "[font_size=100]Wave %d[/font_size]" % wave
    
    var t = create_tween()
    t.set_ease(Tween.EASE_IN_OUT)
    t.set_trans(Tween.TRANS_CUBIC)
    
    visible = true
    t.tween_property(self, "modulate:a", 1, 0.5)
    t.parallel().tween_property(self, "visual_position:y", 0, 0.5)
    
    t.tween_interval(4)

    t.tween_property(self, "modulate:a", 0, 0.5)
    t.parallel().tween_property(self, "visual_position:y", -50, 0.5)

    t.tween_callback(self._hide)

func _hide():
    visible = false
