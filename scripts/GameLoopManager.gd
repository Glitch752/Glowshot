extends Node

var player_pos: Vector2 = Vector2.ZERO

signal bullets_changed(new: int)
signal health_changed(new: float)
signal wave_changed(new: int)

signal end_wave()

## Emitted when an enemy should be spawened.
signal spawn_enemy()

var max_bullets: int = 3
var bullets_held: int = 3:
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
        return 5 + wave * 2

var wave_spawn_interval: float:
    get():
        return 30.0 / wave_enemies_total

func take_damage(amount: float):
    health -= amount
    # TODO: hit sounds and juice

func begin_wave():
    wave += 1
    wave_enemies_spawned = 0

    var t = create_tween()
    t.set_loops(wave_enemies_total)
    t.tween_callback(_spawn_enemy)
    t.tween_interval(wave_spawn_interval)
    t.play()

func _spawn_enemy():
    if wave_enemies_spawned < wave_enemies_total:
        wave_enemies_spawned += 1
        spawn_enemy.emit()

func _physics_process(delta: float) -> void:
    if health <= 0:
        # TODO: Game over
        print("game over! oops")
        return
    
    if health < 1:
        # Slowly regenerate health over time
        health += delta * 0.01

    if wave_enemies_spawned >= wave_enemies_total and get_tree().get_nodes_in_group("enemy").size() == 0:
        end_wave.emit()