package ld58

import rl "vendor:raylib"


v2f :: [2]f32
v2i :: [2]i32


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


DrawSprite :: proc(sprite_id: SpriteID, pos: v2f, size: v2f) {
	sprite: Sprite = Sprites[sprite_id]

	rl.DrawTexturePro(
		ImageRefs[sprite.image_ref_id].tex,
		sprite.frames[sprite.current_frame],
		{pos.x, pos.y, size.x, size.y},
		{0, 0},
		0.0,
		rl.WHITE,
	)
}
