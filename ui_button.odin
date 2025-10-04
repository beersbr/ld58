package ld58

import rl "vendor:raylib"

ButtonState :: enum {
	UP,
	HOVER,
	DOWN_INSIDE,
	DOWN_OUTSIDE,
}


UIButtonRenderColor :: [ButtonState]rl.Color
UIButtonRenderSprite :: [ButtonState]Sprite

UIButtonRenderInfo :: union {
	UIButtonRenderColor,
	UIButtonRenderSprite,
}

UIButton :: struct {
	rect:        rl.Rectangle,
	render_info: UIButtonRenderInfo,
	text:        cstring,
	state:       ButtonState,
}

UpdateButton :: proc(button: UIButton, dt: f32) {
}


DrawButton :: proc(button: UIButton) {
}
