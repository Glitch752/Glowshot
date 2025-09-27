@tool

## I got tired of Godot's janky terrain system so I made my own.

extends TileMapLayer

@export_tool_button("Autotile") var _tool_autotile = _autotile

var AUTOTILE_LOOKUP: Dictionary[String, Vector2i] = {
    # Order: up, right, down, left
    # 0 = empty, 1 = filled
    "0000": Vector2i(0, 3),
    
    "1000": Vector2i(0, 2),
    "1010": Vector2i(0, 1),
    "0010": Vector2i(0, 0),

    "0100": Vector2i(1, 3),
    "0101": Vector2i(2, 3),
    "0001": Vector2i(3, 3),

    "1111": Vector2i(2, 1),
    
    "0111": Vector2i(2, 0),
    "1011": Vector2i(3, 1),
    "1101": Vector2i(2, 2),
    "1110": Vector2i(1, 1),

    "0110": Vector2i(1, 0),
    "0011": Vector2i(3, 0),
    "1001": Vector2i(3, 2),
    "1100": Vector2i(1, 2),
}

func _autotile():
    var used_cells = get_used_cells()
    var used_cell_lookup: Dictionary[Vector2i, bool] = {}
    for cell in used_cells:
        var tile_data = get_cell_tile_data(cell)
        if !tile_data.get_custom_data("empty"):
            used_cell_lookup[cell] = true
    
    for cell in used_cells:
        var tile_data = get_cell_tile_data(cell)
        if !tile_data.get_custom_data("empty"):
            var key = ""
            key += "1" if used_cell_lookup.has(cell + Vector2i(0, -1)) else "0"
            key += "1" if used_cell_lookup.has(cell + Vector2i(1, 0)) else "0"
            key += "1" if used_cell_lookup.has(cell + Vector2i(0, 1)) else "0"
            key += "1" if used_cell_lookup.has(cell + Vector2i(-1, 0)) else "0"
            if AUTOTILE_LOOKUP.has(key):
                set_cell(cell, 1, AUTOTILE_LOOKUP[key], 0)
            else:
                # Fallback to a default tile if no match is found
                set_cell(cell, 1, Vector2i(0, 3), 0)
