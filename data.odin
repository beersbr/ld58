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
	sprite_id:   SpriteID,
	growth_time: f32,
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
	growth_timer:  f32,
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
	tick_rate:      f32,
	tick_timer:     f32,
	tiles_now:      [NUM_TILES]Tile,
	tiles_last:     [NUM_TILES]Tile,
	occupants:      [dynamic]Occupant,
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


ImageID :: enum {
	FARM_ATLAS,
	CURSOR_ATLAS,
}


SpriteID :: enum {
	TILE_GROUND_0,
	TILE_GROUND_1,
	TILE_GROUND_2,
	CURSOR_UP,
	SEED_1,
	CARROT_SEED_BAG,
	CARROT_SEED,
	CARROT_1,
	CARROT_2,
	CARROT_3,
	CARROT_4,
	CARROT_5,
}

GameUIButtonID :: enum {
	CURSOR_BUTTON,
	SEED_BUTTON_CARROT,
}

GroundType :: enum {
	SOIL,
	GRASS,
}

GroundStatus :: enum {
	DRY,
	WETs,
}

ToolID :: enum {
	CURSOR,
	SEED_CARROT,
}

PlantTypeID :: enum {
	NONE,
	CARROT,
	// TOMATO,
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


IMAGE_REFS: [ImageID]ImageRef = {
	.FARM_ATLAS = {path = "./resources/cozy_farm_global.png"},
	.CURSOR_ATLAS = {path = "./resources/_fullset_cursors.png"},
}


SPRITES: [SpriteID]Sprite = {
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
	.CURSOR_UP = {
		image_ref_id = .CURSOR_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{16, 32, 16, 15}},
		num_frames = 1,
	},
	.SEED_1 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{256, 544, 16, 16}},
		num_frames = 1,
	},
	.CARROT_SEED_BAG = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{240, 544, 16, 16}},
		num_frames = 1,
	},
	.CARROT_SEED = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{256, 544, 16, 16}},
		num_frames = 1,
	},
	.CARROT_1 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{272, 544, 16, 16}},
		num_frames = 1,
	},
	.CARROT_2 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{288, 544, 16, 16}},
		num_frames = 1,
	},
	.CARROT_3 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{304, 544, 16, 16}},
		num_frames = 1,
	},
	.CARROT_4 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{320, 544, 16, 16}},
		num_frames = 1,
	},
	.CARROT_5 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{336, 544, 16, 16}},
		num_frames = 1,
	},
}


DEFAULT_TILE :: Tile {
	ground_type   = .SOIL,
	ground_status = .DRY,
}


TOOLS: [ToolID]Tool = {
	.CURSOR = {sprite_id = .CURSOR_UP},
	.SEED_CARROT = {sprite_id = .SEED_1},
}


DEBUG_BUTTON_RENDER_INFO: UIButtonRenderColor = {
	.UP           = rl.Color{170, 170, 170, 255},
	.HOVER        = rl.Color{128, 128, 128, 255},
	.DOWN_INSIDE  = rl.Color{50, 50, 50, 255},
	.DOWN_OUTSIDE = rl.Color{128, 0, 128, 255},
}


PLANT_DATA: [PlantTypeID]PlantData = {
	.NONE = {},
	.CARROT = {
		growth_rate = 1.0,
		num_stages = 6,
		stages = {
			{sprite_id = .CARROT_SEED, growth_time = 10.0},
			{sprite_id = .CARROT_1, growth_time = 10.0},
			{sprite_id = .CARROT_2, growth_time = 10.0},
			{sprite_id = .CARROT_3, growth_time = 10.0},
			{sprite_id = .CARROT_4, growth_time = 10.0},
			{sprite_id = .CARROT_5, growth_time = 10.0},
		},
	},
}

TILE_NBR_EVAL_FN: map[NbrMap]PlantEvalProc = {
	{
		.N = PlantEvalData{.CARROT, 6},
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

			if !ok {
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
					growth_timer  = 0,
				}
			}
		}


	},
}
