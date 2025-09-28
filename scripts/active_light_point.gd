@tool

extends PointLight2D

func _get_texture_scale() -> float:
    return log(intensity / 2 + 1 + GameLoopManager.brightness_upgrade_level) / log(2) * 3
func _get_energy() -> float:
    return min(1.5, log(intensity / 2 + 1 + GameLoopManager.brightness_upgrade_level) / log(2))

@export var intensity: float = 1:
    set(val):
        intensity = val
        var t = create_tween()
        t.tween_property(self, "texture_scale", _get_texture_scale(), 0.25)
        t.parallel().tween_property(self, "energy", _get_energy(), 0.25)

# TODO: Flicker if 0 intensity

func _ready():
    if not Engine.is_editor_hint():
        texture_scale = _get_texture_scale()
        energy = _get_energy()
