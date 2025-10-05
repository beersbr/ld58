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
