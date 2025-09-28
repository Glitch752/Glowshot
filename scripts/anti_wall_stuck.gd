extends Node

static func anti_stuck(node: Node2D, delta: float):
    var tilemap: TileMapLayer = node.get_tree().current_scene.get_node("%WallLayer")
    if tilemap.filled_at_position(node.global_position):
        # node.modulate = Color.BLUE * randf()

        var stuck_timer = node.get_meta("stuck_timer", 2)
        node.set_meta("stuck_timer", stuck_timer - delta)

        if stuck_timer <= 0:
            # We're (probably? idk) stuck. Snap to the nearest non-empty cell
            print("Unstucked! This is probably bad but godot's physics are funky so whatever")
            var best_dist = 99999.0
            var best_pos = Vector2.ZERO
            for cell in tilemap.unused_cell_lookup.keys():
                var cell_pos = tilemap.to_global(tilemap.map_to_local(cell))
                var dist = cell_pos.distance_squared_to(node.global_position)
                if dist < best_dist:
                    best_dist = dist
                    best_pos = cell_pos
            node.global_position = best_pos
            if node is RigidBody2D:
                node.linear_velocity = Vector2.ZERO
                node.angular_velocity = 0

    else:
        # node.modulate = Color.WHITE

        node.set_meta("stuck_timer", 0.25)
