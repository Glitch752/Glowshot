extends Node

func play_sound_at(stream: AudioStream, global_position: Vector2, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
    var player = AudioStreamPlayer2D.new()
    player.stream = stream
    player.volume_db = volume_db
    player.pitch_scale = pitch_scale
    player.global_position = global_position

    get_tree().current_scene.add_child(player)
    
    player.play()
    player.finished.connect(player.queue_free)
