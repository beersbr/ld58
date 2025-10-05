package ld58

import "core:fmt"
import "core:math"
import mem "core:mem"
import rl "vendor:raylib"


GameData :: struct {
	tick_rate:      f32,
	tick_timer:     f32,
	tiles_now:      [NUM_TILES]Tile,
	tiles_last:     [NUM_TILES]Tile,
	occupants:      [dynamic]Occupant,
	plants:         [dynamic]Plant,
	mouse_pos:      v2f,
	mouse_pos_last: v2f,
	tool_id:        ToolID,
}

GAME_UI_BUTTONS: [GameUIButtonID]UIButton = {
	.CURSOR_BUTTON = {
		rect = rl.Rectangle{730, 50, 100, 65},
		render_info = DEBUG_BUTTON_RENDER_INFO,
		state = .UP,
		sprite_id = .CURSOR_UP,
	},
	.SEED_BUTTON_CARROT = {
		rect = rl.Rectangle{730, 125, 100, 65},
		render_info = DEBUG_BUTTON_RENDER_INFO,
		state = .UP,
		sprite_id = .CARROT_SEED_BAG,
	},
}


GAME_UI_BUTTON_ACTIONS: [GameUIButtonID]ButtonCallback = {
	.CURSOR_BUTTON = proc(button: ^UIButton, game_data: ^GameData) {
		game_data.tool_id = .CURSOR
	},
	.SEED_BUTTON_CARROT = proc(button: ^UIButton, game_data: ^GameData) {
		game_data.tool_id = .SEED_CARROT

	},
}


TOOL_ACTIONS: [ToolID]ToolAction = {
	.CURSOR = proc(tool_id: ToolID, tile: ^Tile, game_data: ^GameData) {

	},
	.SEED_CARROT = proc(tool_id: ToolID, tile: ^Tile, game_data: ^GameData) {
		tile_coord := index_to_coord(tile.index)

		if tile.plant == nil {
			append(
				&game_data.plants,
				Plant {
					born_at = rl.GetTime(),
					health = 10,
					pos = v2f {
						cast(f32)tile_coord.x * TILE_SIZE,
						cast(f32)tile_coord.y * TILE_SIZE,
					},
					vel = v2f{},
					tile_index = tile.index,
					plant_type_id = .CARROT,
					current_stage = 0,
					growth_timer = 0,
				},
			)
			// TODO(Brett): there should be a pooled list somewhere
		}

	},
}


game_data_init :: proc(game_data: ^GameData) {
	game_data.occupants = make([dynamic]Occupant, 0, NUM_TILES * 8)
	game_data.plants = make([dynamic]Plant, 0, NUM_TILES)

	game_data.tick_rate = 1.0
	game_data.tool_id = .CURSOR

	for &tile, idx in game_data.tiles_now {
		tile = DEFAULT_TILE
		tile.index = cast(i32)idx
	}
}


update_game :: proc(game_data: ^GameData, dt: f32) {
	mouse_pos: v2f = rl.GetMousePosition()

	game_data.mouse_pos_last = game_data.mouse_pos
	game_data.mouse_pos = rl.GetMousePosition()

	for button_id, idx in GameUIButtonID {
		button: ^UIButton = &GAME_UI_BUTTONS[button_id]
		update_button(button)
		if button.pressed {
			GAME_UI_BUTTON_ACTIONS[button_id](button, game_data)
		}
	}

	if rl.CheckCollisionPointRec(
		mouse_pos,
		rl.Rectangle{0, 0, TILE_SIZE * TILES_WIDTH, TILE_SIZE * TILES_HEIGHT},
	) {
		if rl.IsMouseButtonPressed(.LEFT) {
			tile_coord := v2i_to_coord(to_v2i(mouse_pos))
			tile_index := coord_to_index(tile_coord)
			tile := game_data.tiles_now[tile_index]

			TOOL_ACTIONS[game_data.tool_id](game_data.tool_id, &tile, game_data)
		}
	}

	for &plant, idx in game_data.plants {
		plant_data: PlantData = PLANT_DATA[plant.plant_type_id]
		plant_stage: PlantDataStage = plant_data.stages[plant.current_stage]

		plant.growth_timer += dt
		if plant.growth_timer > plant_stage.growth_time &&
		   plant.current_stage < plant_data.num_stages {

			plant.growth_timer = plant.growth_timer - plant_stage.growth_time

			if plant.current_stage + 1 < plant_data.num_stages {
				plant.current_stage += 1
			}
		}
	}

	for &occupant, idx in game_data.occupants {
	}

}


draw_game :: proc(game_data: ^GameData) {

	for &tile, idx in game_data.tiles_now {
		// DrawSprite :: proc(sprite_id: SpriteID, pos: v2f, size: v2f) {
		coord_i := index_to_coord(i32(idx))
		coord_f := to_v2f(coord_i)

		draw_sprite(.TILE_GROUND_0, coord_f * TILE_SIZE, {TILE_SIZE, TILE_SIZE})

		if rl.CheckCollisionPointRec(
			game_data.mouse_pos,
			rl.Rectangle{coord_f.x * TILE_SIZE, coord_f.y * TILE_SIZE, TILE_SIZE, TILE_SIZE},
		) {
			if game_data.tool_id != .CURSOR {
				rl.DrawRectangle(
					coord_i.x * TILE_SIZE,
					coord_i.y * TILE_SIZE,
					TILE_SIZE,
					TILE_SIZE,
					rl.Color{128, 128, 128, 128},
				)
			}
		}
	}

	for &plant in game_data.plants {
		plant_data: PlantData = PLANT_DATA[plant.plant_type_id]
		plant_stage: PlantDataStage = plant_data.stages[plant.current_stage]

		draw_sprite(plant_stage.sprite_id, plant.pos, {TILE_SIZE, TILE_SIZE})
	}
	for &occupant in game_data.occupants {
		draw_sprite(occupant.sprite_id, occupant.pos, {TILE_SIZE, TILE_SIZE})
	}

	for &button in GAME_UI_BUTTONS {
		draw_button(&button)
	}

	current_tool: Tool = TOOLS[game_data.tool_id]
	draw_sprite(current_tool.sprite_id, game_data.mouse_pos, {TILE_SIZE, TILE_SIZE})

}

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LD - 58")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	init_resources()

	game_data: GameData = {}

	game_data_init(&game_data)
	frame_time: f32

	rl.HideCursor()

	for !rl.WindowShouldClose() {
		frame_time := rl.GetFrameTime()

		if rl.IsKeyPressed(rl.KeyboardKey.Q) {
			break
		}

		update_game(&game_data, frame_time)

		rl.BeginDrawing()
		{
			rl.ClearBackground({10, 10, 26, 255})
			draw_game(&game_data)
		}
		rl.EndDrawing()
	}
}
