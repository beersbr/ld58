package ld58

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WINDOW_WIDTH: i32 : 1280
WINDOW_HEIGHT: i32 : 720

ImageID :: enum {
	FARM_ATLAS,
	BUTTERFLY_ATLAS,
}

ImageRefs: [ImageID]ImageRef = {
	.FARM_ATLAS = {path = "/home/brett/Downloads/farm/full version/global.png"},
	.BUTTERFLY_ATLAS = {
		path = "/home/brett/Downloads/Cute_Fantasy/Animals/Butterfly/Butterfly.png",
	},
}


SpriteID :: enum {
	BUTTERFLY_BLUE,
	TILE_GROUND_0,
	TILE_GROUND_1,
	TILE_GROUND_2,
	// FENCE_N,
	// FENCE_NE,
	// FENCE_E,
	// FENCE_SE,
	// FENCE_S,
	// FENCE_SW,
	// FENCE_W,
	// FENCE_NW,
}

Sprites: [SpriteID]Sprite = {
	.BUTTERFLY_BLUE = {
		image_ref_id = .BUTTERFLY_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{0, 0, 16, 16}, {8, 16, 16, 16}},
		num_frames = 2,
	},
	.TILE_GROUND_0 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{80, 96, 16, 16}},
		num_frames = 1,
	},
	.TILE_GROUND_1 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{96, 96, 16, 16}},
		num_frames = 1,
	},
	.TILE_GROUND_2 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{112, 96, 16, 16}},
		num_frames = 1,
	},
	// .FENCE_N = {
	// 	image_ref_id = .FARM_ATLAS,
	// 	size = {16, 16},
	// 	current_frame = 0,
	// 	frames = {{192, 464, 16, 16}},
	// 	num_frames = 1,
	// },
	// .FENCE_NE = {
	// 	image_ref_id = .FARM_ATLAS,
	// 	size = {16, 16},
	// 	current_frame = 0,
	// 	frames = {{208, 464, 16, 16}},
	// 	num_frames = 1,
	// },
}


UIButtonID :: enum {
	PlayButton,
}


UIButtons :: [UIButtonID]UIButton{}


InitData :: proc() {
	for &image_data in ImageRefs {
		image_data.tex = rl.LoadTexture(image_data.path)
		image_data.size = v2i{image_data.tex.width, image_data.tex.height}
	}
}


GroundType :: enum {
	SOIL,
	GRASS,
}

GroundStatus :: enum {
	DRY,
	WET,
}

ProduceType :: enum {
	NONE,
}

OccupantState :: enum {}
OccupantType :: enum {}

TILE_MAX_OCCUPANTS :: 4

Occupant :: struct {
	pos:   v2f,
	vel:   v2f,
	state: OccupantState,
	type:  OccupantType,
}

Tile :: struct {
	ground_type:   GroundType,
	ground_status: GroundStatus,
	produce:       ProduceType,
	occupants:     [TILE_MAX_OCCUPANTS]Occupant,
}

DefaultTile :: Tile {
	ground_type   = .SOIL,
	ground_status = .DRY,
}

TILE_SIZE :: 32
TILES_WIDTH :: 16
TILES_HEIGHT :: 16
NUM_TILES :: TILES_WIDTH * TILES_HEIGHT

index_to_coord :: proc(index: i32) -> v2i {
	return {math.floor_div(index, TILES_WIDTH), index % TILES_WIDTH}
}

coord_to_index :: proc(coord: v2i) -> i32 {
	return coord.x + coord.y * TILES_WIDTH
}

GameData :: struct {
	tick_rate:  f32,
	tiles_now:  [NUM_TILES]Tile,
	tiles_last: [NUM_TILES]Tile,
}

InitGameData :: proc(game_data: ^GameData) {
	game_data.tick_rate = 1.0
	for &tile in game_data.tiles_now {
		tile = DefaultTile
	}
}

UpdateGame :: proc(game_data: ^GameData, dt: f32) {

}


DrawGame :: proc(game_data: ^GameData) {
	for &tile, idx in game_data.tiles_now {
		// DrawSprite :: proc(sprite_id: SpriteID, pos: v2f, size: v2f) {
		coord_i := index_to_coord(i32(idx))
		coord_f := to_v2f(coord_i)
		DrawSprite(.TILE_GROUND_0, coord_f * TILE_SIZE, {32, 32})
	}
}


main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Asteroids")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	InitData()

	game_data: GameData = {}

	InitGameData(&game_data)
	frame_time: f32

	for !rl.WindowShouldClose() {
		frame_time := rl.GetFrameTime()

		if rl.IsKeyPressed(rl.KeyboardKey.Q) {
			break
		}

		UpdateGame(&game_data, frame_time)

		rl.BeginDrawing()
		{
			rl.ClearBackground({10, 10, 26, 255})
			DrawGame(&game_data)
			// DrawSprite(.FENCE_NE, {200, 500}, {16, 16})
			// DrawSprite(.FENCE_N, {184, 500}, {16, 16})
		}
		rl.EndDrawing()
	}
}
