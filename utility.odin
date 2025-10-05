package ld58

import "core:math"

import rl "vendor:raylib"

index_to_coord :: proc(index: i32) -> v2i {
	return {index % TILES_WIDTH, math.floor_div(index, TILES_WIDTH)}
}

coord_to_index :: proc(coord: v2i) -> i32 {
	return coord.x + coord.y * TILES_WIDTH
}


v2f_to_coord :: proc(pos: v2f) -> v2i {
	return {i32(math.floor_div(i32(pos.x), TILE_SIZE)), i32(math.floor_div(i32(pos.y), TILE_SIZE))}
}


v2i_to_coord :: proc(pos: v2i) -> v2i {
	return {pos.x / TILE_SIZE, pos.y / TILE_SIZE}
}

init_resources :: proc() {
	for &image_data in IMAGE_REFS {
		image_data.tex = rl.LoadTexture(image_data.path)
		image_data.size = v2i{image_data.tex.width, image_data.tex.height}
	}
}
