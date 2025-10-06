#+feature dynamic-literals

package ld58

import "core:fmt"
import rl "vendor:raylib"

WINDOW_WIDTH: i32 : 1280
WINDOW_HEIGHT: i32 : 720

TILE_SIZE :: 45
TILES_WIDTH :: 16
TILES_HEIGHT :: 16
NUM_TILES :: TILES_WIDTH * TILES_HEIGHT
TILE_MAX_OCCUPANTS :: 4

MAX_PLANT_STAGES :: 6

PlantEvalDataWrapper :: union {
	bool,
	PlantEvalData,
}

NbrMap :: [NbrDir]PlantEvalDataWrapper

// ----------------------------------------------

ToolAction :: proc(tool_id: ToolID, tile_index: i32, game_data: ^GameData)
ButtonCallback :: proc(button: ^UIButton, game_data: ^GameData)

// TODO: fix the plant reference.. just use an ID please
PlantEvalProc :: proc(tile: ^Tile, nbr_map: NbrMap, game_data: ^GameData)

// ----------------------------------------------
Tool :: struct {
	sprite_id: SpriteID,
}

Doodad :: struct {
	pos:       v2f,
	sprite_id: SpriteID,
	size:      v2f,
}

BaseEntity :: struct {
	born_at:    f64,
	health:     f32,
	pos:        v2f,
	vel:        v2f,
	tile_index: i32,
}

Occupant :: struct {
	using entity: BaseEntity,
	sprite_id:    SpriteID,
	type:         OccupantType,
}

PlantDataStage :: struct {
	sprite_id:    SpriteID,
	growth_ticks: i32,
}

PlantData :: struct {
	growth_rate: f32,
	stages:      [MAX_PLANT_STAGES]PlantDataStage,
	num_stages:  i32,
}

Plant :: struct {
	using entity:  BaseEntity,
	current_stage: i32,
	plant_type_id: PlantTypeID,
	growth_ticks:  i32,
}

Tile :: struct {
	index:         i32,
	ground_type:   GroundType,
	ground_status: GroundStatus,
	plant:         ^Plant,
	occupants:     [10]^Occupant,
	num_occupants: u32,
}

GameData :: struct {
	did_tick:       bool,
	tick_rate:      f32,
	tick_timer:     f32,
	tick_time:      f32,
	total_ticks:    i32,
	tiles_now:      [NUM_TILES]Tile,
	tiles_last:     [NUM_TILES]Tile,
	occupants:      [dynamic]Occupant,
	doodads_pool:   Pool(Doodad),
	plant_pool:     Pool(Plant),
	mouse_pos:      v2f,
	mouse_pos_last: v2f,
	tool_id:        ToolID,
}

PlantEvalData :: struct {
	// nbr_dir:       NbrDir,
	plant_type_id: PlantTypeID,
	current_stage: i32,
	// tile_index:    i32,
}

// ----------------------------------------------
NbrDir :: enum {
	NW,
	N,
	NE,
	E,
	SE,
	S,
	SW,
	W,
}


GroundType :: enum {
	SOIL,
	GRASS,
}

GroundStatus :: enum {
	DRY,
	WETs,
}

PlantTypeID :: enum {
	CARROT,
	TOMATO,
	// STRAWBERRY,
	// PUMPKIN,
	// CORN,
	// WATER_MELLON,
	// RADISH,
	// POTATO,
	// LETTUCE,
	// SUGAR_CANE,
	// EGG_PLANT,
	// ROSE,
}

OccupantType :: enum {
	BUG,
}

// --------------------------------------------


// --------------------------------------------

NBR_MAP: [NbrDir]v2i = {
	.NW = {-1, -1},
	.N  = {0, -1},
	.NE = {1, -1},
	.E  = {1, 0},
	.SE = {1, 1},
	.S  = {0, 1},
	.SW = {-1, 1},
	.W  = {-1, 0},
}


DEFAULT_TILE :: Tile {
	ground_type   = .SOIL,
	ground_status = .DRY,
}


PLANT_DATA: [PlantTypeID]PlantData = {
	.CARROT = {
		growth_rate = 1.0,
		num_stages = 6,
		stages = {
			{sprite_id = .CARROT_SEED, growth_ticks = 5},
			{sprite_id = .CARROT_1, growth_ticks = 5},
			{sprite_id = .CARROT_2, growth_ticks = 5},
			{sprite_id = .CARROT_3, growth_ticks = 5},
			{sprite_id = .CARROT_4, growth_ticks = 5},
			{sprite_id = .CARROT_5, growth_ticks = 5},
		},
	},
	.TOMATO = {
		growth_rate = 1,
		num_stages = 6,
		stages = {
			{sprite_id = .TOMATO_SEED, growth_ticks = 2},
			{sprite_id = .TOMATO_1, growth_ticks = 4},
			{sprite_id = .TOMATO_2, growth_ticks = 4},
			{sprite_id = .TOMATO_3, growth_ticks = 10},
			{sprite_id = .TOMATO_4, growth_ticks = 10},
			{sprite_id = .TOMATO_5, growth_ticks = 10},
		},
	},
}

TILE_NBR_EVAL_FN: map[NbrMap]PlantEvalProc = {
	{
		.N = PlantEvalData{.CARROT, 1},
		.NE = false,
		.E = false,
		.SE = false,
		.S = false,
		.SW = false,
		.W = false,
		.NW = false,
	} = proc(tile: ^Tile, nbr_map: NbrMap, game_data: ^GameData) {

		if tile.plant == nil {
			ok, plant := pool_acquire(&game_data.plant_pool)

			tile_coord: v2i = index_to_coord(tile.index)

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
	{
		.N = PlantEvalData{.CARROT, 3},
		.NE = false,
		.E = PlantEvalData{.CARROT, 3},
		.SE = false,
		.S = PlantEvalData{.CARROT, 3},
		.SW = false,
		.W = PlantEvalData{.CARROT, 3},
		.NW = false,
	} = proc(tile: ^Tile, nbr_map: NbrMap, game_data: ^GameData) {

		if tile.plant == nil {
			ok, plant := pool_acquire(&game_data.plant_pool)

			tile_coord: v2i = index_to_coord(tile.index)

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
					plant_type_id = .TOMATO,
					current_stage = 0,
					growth_ticks  = 0,
				}
				tile.plant = plant
			}
		}
	},
}
