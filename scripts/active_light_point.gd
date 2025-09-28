@tool

extends PointLight2D

@export var intensity: float = 1:
    set(val):
        var t = create_tween()
        t.tween_property(self, "texture_scale", val * 6, 0.25)

# TODO: Flicker if 0 intensity
