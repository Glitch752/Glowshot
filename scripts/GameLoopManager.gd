extends Node

var player_pos: Vector2 = Vector2.ZERO

signal max_bullets_changed(new: int)
signal bullets_changed(new: int)
signal health_changed(new: float)
signal wave_changed(new: int)
signal enemies_remaining_changed(new: int)

signal end_wave()

## Emitted when an enemy should be spawened.
signal spawn_enemy()

var end_wave_menu_open: bool = false
var death_screen_open: bool = false
var wave_active: bool = false

var brightness_upgrade_level: int = 1
var damage_upgrade_level: int = 1
var max_bullets_upgrade_level: int = 1:
    set(val):
        max_bullets = 1 + val

var max_bullets: int = 2:
    set(val):
        max_bullets = val
        max_bullets_changed.emit(val)
var bullets_held: int = 2:
    set(val):
        bullets_held = val
        bullets_changed.emit(val)

var health: float = 1:
    set(val):
        health = min(1, max(0, val))
        health_changed.emit(val)

var wave: int = 0:
    set(val):
        wave = val
        wave_changed.emit(val)

var wave_enemies_spawned: int = 0
var wave_enemies_total: int:
    get():
        return 3 + wave * 5

var wave_enemies_killed: int = 0:
    set(val):
        wave_enemies_killed = val
        enemies_remaining_changed.emit(wave_enemies_remaining)
var wave_enemies_remaining: int:
    get():
        return wave_enemies_total - wave_enemies_killed

var wave_spawn_interval: float:
    get():
        return 30.0 / wave_enemies_total

var wave_enemy_health: int:
    get():
        return 1 + ceili((wave - 1) * 0.75)

func take_damage(amount: float):
    health -= amount
    # TODO: hit sounds and juice

func begin_wave():
    wave += 1
    wave_enemies_spawned = 0
    wave_enemies_killed = 0
    wave_active = true

    var t = create_tween()
    t.set_loops(wave_enemies_total)
    t.tween_callback(_spawn_enemy)
    t.tween_interval(wave_spawn_interval)

func reset():
    brightness_upgrade_level = 1
    damage_upgrade_level = 1
    max_bullets_upgrade_level = 1
    health = 1
    wave = 0
    bullets_held = max_bullets

    end_wave_menu_open = false
    death_screen_open = false
    wave_active = false
    wave_enemies_spawned = 0
    wave_enemies_killed = 0

    begin_wave()

func _spawn_enemy():
    if wave_enemies_spawned < wave_enemies_total:
        wave_enemies_spawned += 1
        spawn_enemy.emit()

const DEATH_SCREEN = preload("res://ui/DeathScreen.tscn")

func _physics_process(delta: float) -> void:
    if health <= 0:
        if not death_screen_open:
            death_screen_open = true
            var ds = DEATH_SCREEN.instantiate()
            get_tree().current_scene.add_child(ds)
        return
    
    if health < 1:
        # Slowly regenerate health over time
        health += delta * 0.02

    if wave_active and wave_enemies_spawned >= wave_enemies_total and get_tree().get_nodes_in_group("enemy").size() == 0:
        end_wave.emit()
        wave_active = false