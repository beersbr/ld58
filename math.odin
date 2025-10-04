package ld58

v2f :: [2]f32
v2i :: [2]i32


to_v2f :: proc(a: v2i) -> v2f {
	return {f32(a.x), f32(a.y)}
}

to_v2i :: proc(a: v2f) -> v2i {
	return {i32(a.x), i32(a.y)}
}
