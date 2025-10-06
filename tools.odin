package ld58

import rl "vendor:raylib"

ToolID :: enum {
	CURSOR,
	SEED_CARROT,
	HARVEST_TOOL,
}


TOOLS: [ToolID]Tool = {
	.CURSOR = {sprite_id = .CURSOR_COLOR_UP},
	.SEED_CARROT = {sprite_id = .SEED_1},
	.HARVEST_TOOL = {sprite_id = .HARVEST_TOOL},
}


TOOL_ACTIONS: [ToolID]ToolAction = {
	.HARVEST_TOOL = proc(tool_id: ToolID, tile_index: i32, game_data: ^GameData) {
		tile: ^Tile = &game_data.tiles_now[tile_index]
		tile_coord := index_to_coord(tile_index)

		if tile.plant == nil {
			ok, plant := pool_acquire(&game_data.plant_pool)
			if ok {
				plant^ = Plant {
					born_at       = rl.GetTime(),
					health        = 10,
					pos           = v2f {
						cast(f32)tile_coord.x * TILE_SIZE,
						cast(f32)tile_coord.y * TILE_SIZE,
					},
					vel           = v2f{},
					tile_index    = tile.index,
					plant_type_id = .CARROT,
					current_stage = 0,
					growth_ticks  = 0,
				}
				tile.plant = plant
			}
		}
	},
	.CURSOR = proc(tool_id: ToolID, tile_index: i32, game_data: ^GameData) {
		tile: ^Tile = &game_data.tiles_now[tile_index]
		tile_coord := index_to_coord(tile_index)

		if tile.plant == nil {
			return
		}

		plant_data := PLANT_DATA[tile.plant.plant_type_id]
		if tile.plant.current_stage == plant_data.num_stages {
		} else {
			tile.plant.growth_ticks += 1
		}
	},
	.SEED_CARROT = proc(tool_id: ToolID, tile_index: i32, game_data: ^GameData) {

		tile: ^Tile = &game_data.tiles_now[tile_index]
		tile_coord := index_to_coord(tile_index)

		if tile.plant == nil {
			ok, plant := pool_acquire(&game_data.plant_pool)
			if ok {
				plant^ = Plant {
					born_at       = rl.GetTime(),
					health        = 10,
					pos           = v2f {
						cast(f32)tile_coord.x * TILE_SIZE,
						cast(f32)tile_coord.y * TILE_SIZE,
					},
					vel           = v2f{},
					tile_index    = tile.index,
					plant_type_id = .CARROT,
					current_stage = 0,
					growth_ticks  = 0,
				}
				tile.plant = plant
			}
		}
	},
}
