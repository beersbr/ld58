package ld58

import rl "vendor:raylib"

ButtonState :: enum {
	// DISABLED,
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
	pressed:     bool,
	sprite_id:   SpriteID,
	hidden:      bool,
}

update_button :: proc(button: ^UIButton) {
	@(static) active_button: ^UIButton

	if button.hidden == true {
		return
	}
	button.pressed = false

	mouse_pos: v2f = rl.GetMousePosition()

	lmb_down: bool = rl.IsMouseButtonDown(.LEFT)
	lmb_released: bool = rl.IsMouseButtonReleased(.LEFT)

	if rl.CheckCollisionPointRec(mouse_pos, button.rect) {
		if button.state == .UP {
			if lmb_down {
				button.state = .DOWN_INSIDE
				active_button = button

			} else if lmb_released {
				button.state = .HOVER
				button.pressed = true
			} else {
				button.state = .HOVER
			}
		} else if button.state == .HOVER {
			if lmb_down {
				button.state = .DOWN_INSIDE
			} else if lmb_released {
				button.state = .HOVER
				button.pressed = true
			} else {
				button.state = .HOVER
			}
		} else if button.state == .DOWN_INSIDE {
			if lmb_down {
				button.state = .DOWN_INSIDE
			} else if lmb_released {
				button.state = .HOVER
				button.pressed = true
			}

		} else if button.state == .DOWN_OUTSIDE {
			if lmb_down {
				button.state = .DOWN_INSIDE
			} else if lmb_released {
				button.state = .HOVER
				button.pressed = true
			}
		}
	} else {
		if button.state == .DOWN_INSIDE {
			if lmb_down {
				button.state = .DOWN_OUTSIDE
			} else if lmb_released {
				button.state = .UP
			}
		} else if button.state == .DOWN_OUTSIDE {
			if lmb_released {
				button.state = .UP
			}
		} else {
			button.state = .UP
			active_button = nil
		}
	}
}

draw_button :: proc(button: ^UIButton) {

	if button.hidden == true {
		return
	}

	switch render_info in button.render_info {
	case UIButtonRenderColor:
		rl.DrawRectangle(
			i32(button.rect.x),
			i32(button.rect.y),
			i32(button.rect.width),
			i32(button.rect.height),
			render_info[button.state],
		)

		draw_sprite(
			button.sprite_id,
			{
				cast(f32)button.rect.x + (button.rect.width - 32) / 2,
				cast(f32)button.rect.y + (button.rect.height - 32) / 2,
			},
			{32, 32},
		)

	case UIButtonRenderSprite:

	}
}
