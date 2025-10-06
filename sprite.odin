package ld58

import rl "vendor:raylib"


ImageRef :: struct {
	path: cstring,
	size: v2i,
	tex:  rl.Texture2D,
}


Sprite :: struct {
	texture_id:    rl.Texture2D,
	image_ref_id:  ImageID,
	size:          v2i,
	current_frame: i32,
	num_frames:    i32,
	frames:        []rl.Rectangle,
}

ImageID :: enum {
	FARM_ATLAS,
	CURSOR_ATLAS,
	BACKGROUND_RIGHT,
	CURSOR_COLOR_ATLAS,
	PARTICLES_ATLAS,
}

SpriteID :: enum {
	BACKGROUND_RIGHT,
	TILE_GROUND_0,
	TILE_GROUND_1,
	TILE_GROUND_2,
	CURSOR_UP,
	CURSOR_COLOR_UP,
	HARVEST_TOOL,
	SEED_1,
	CARROT_SEED_BAG,
	CARROT_SEED,
	CARROT_1,
	CARROT_2,
	CARROT_3,
	CARROT_4,
	CARROT_5,
	TOMATO_SEED_BAG,
	TOMATO_SEED,
	TOMATO_1,
	TOMATO_2,
	TOMATO_3,
	TOMATO_4,
	TOMATO_5,
}

IMAGE_REFS: [ImageID]ImageRef = {
	.FARM_ATLAS = {path = "./resources/cozy_farm_global.png"},
	.CURSOR_ATLAS = {path = "./resources/_fullset_cursors.png"},
	.BACKGROUND_RIGHT = {path = "./resources/background_right.png"},
	.CURSOR_COLOR_ATLAS = {path = "./resources/cursors.png"},
	.PARTICLES_ATLAS = {path = "./resources/flora_particle.png.png"},
}


SPRITES: [SpriteID]Sprite = {
	.BACKGROUND_RIGHT = {
		image_ref_id = .BACKGROUND_RIGHT,
		size = {560, 720},
		current_frame = 0,
		frames = {{0, 0, 560, 720}},
		num_frames = 1,
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
	.CURSOR_UP = {
		image_ref_id = .CURSOR_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{16, 32, 16, 15}},
		num_frames = 1,
	},
	.CURSOR_COLOR_UP = {
		image_ref_id = .CURSOR_COLOR_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{16, 16, 16, 15}},
		num_frames = 1,
	},
	.HARVEST_TOOL = {
		image_ref_id = .CURSOR_COLOR_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{64, 48, 16, 15}},
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
	.TOMATO_SEED_BAG = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{240, 560, 16, 16}},
		num_frames = 1,
	},
	.TOMATO_SEED = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{256, 560, 16, 16}},
		num_frames = 1,
	},
	.TOMATO_1 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{272, 560, 16, 16}},
		num_frames = 1,
	},
	.TOMATO_2 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{288, 560, 16, 16}},
		num_frames = 1,
	},
	.TOMATO_3 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{304, 560, 16, 16}},
		num_frames = 1,
	},
	.TOMATO_4 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{320, 560, 16, 16}},
		num_frames = 1,
	},
	.TOMATO_5 = {
		image_ref_id = .FARM_ATLAS,
		size = {16, 16},
		current_frame = 0,
		frames = {{336, 560, 16, 16}},
		num_frames = 1,
	},
}


draw_sprite :: proc(sprite_id: SpriteID, pos: v2f, size: v2f) {
	sprite: Sprite = SPRITES[sprite_id]

	rl.DrawTexturePro(
		IMAGE_REFS[sprite.image_ref_id].tex,
		sprite.frames[sprite.current_frame],
		{pos.x, pos.y, size.x, size.y},
		{0, 0},
		0.0,
		rl.WHITE,
	)
}

animate :: proc(time: ^f32, frame_count: i32, duration: f32) -> i32 {
	return 0
}
