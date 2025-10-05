package ld58

import rl "vendor:raylib"

WINDOW_WIDTH: i32 : 1280
WINDOW_HEIGHT: i32 : 720

TILE_SIZE :: 45
TILES_WIDTH :: 16
TILES_HEIGHT :: 16
NUM_TILES :: TILES_WIDTH * TILES_HEIGHT
TILE_MAX_OCCUPANTS :: 4

MAX_PLANT_STAGES :: 6

// ----------------------------------------------

ToolAction :: proc(tool_id: ToolID, tile: ^Tile, game_data: ^GameData)
ButtonCallback :: proc(button: ^UIButton, game_data: ^GameData)

// ----------------------------------------------

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
	WET,
}

ToolID :: enum {
	CURSOR,
	SEED_CARROT,
}

PlantTypeID :: enum {
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
// --------------------------------------------

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
