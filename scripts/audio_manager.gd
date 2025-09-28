extends Node

var playback: AudioStreamPlaybackPolyphonic

func _ready() -> void:
    var player: AudioStreamPlayer = $AudioStreamPlayer

    var stream = AudioStreamPolyphonic.new()
    stream.polyphony = 32
    
    player.stream = stream
    player.play()
    
    playback = player.get_stream_playback()

func play_sound_at(stream: AudioStream, global_position: Vector2, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
    var player = AudioStreamPlayer2D.new()
    player.stream = stream
    player.volume_db = volume_db
    player.pitch_scale = pitch_scale
    player.global_position = global_position

    get_tree().current_scene.add_child(player)
    
    player.play()
    player.finished.connect(player.queue_free)

func play_sound(stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
    var player = AudioStreamPlayer.new()
    player.stream = stream
    player.volume_db = volume_db
    player.pitch_scale = pitch_scale

    get_tree().current_scene.add_child(player)
    
    player.play()
    player.finished.connect(player.queue_free)


func _enter_tree() -> void:
    get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
    if node is Button:
        node.mouse_entered.connect(play_mouse_enter)
        #node.mouse_exited.connect(mouse_exit)
        node.button_down.connect(play_button_down)
        node.button_up.connect(play_button_up)


func play_mouse_enter() -> void:
    playback.play_stream(preload('res://audio/kenney_ui-audio/click3.ogg'), 0, -15.0, randf_range(0.9, 1.1))

func play_button_down() -> void:
    playback.play_stream(preload('res://audio/kenney_ui-audio/click1.ogg'), 0, -5.0, randf_range(0.9, 1.1))

func play_button_up() -> void:
    playback.play_stream(preload('res://audio/kenney_ui-audio/click1.ogg'), 0, -5.0, randf_range(1.1, 1.3))
