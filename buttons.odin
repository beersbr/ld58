
package ld58

import "core:fmt"
import rl "vendor:raylib"


GameUIButtonID :: enum {
	CURSOR_BUTTON,
	HARVEST_BUTTON,
	SEED_BUTTON_CARROT,
}

DEBUG_BUTTON_RENDER_INFO: UIButtonRenderColor = {
	.UP           = rl.Color{170, 170, 170, 255},
	.HOVER        = rl.Color{128, 128, 128, 255},
	.DOWN_INSIDE  = rl.Color{50, 50, 50, 255},
	.DOWN_OUTSIDE = rl.Color{128, 0, 128, 255},
}


GAME_UI_BUTTONS: [GameUIButtonID]UIButton = {
	.CURSOR_BUTTON = {
		rect = rl.Rectangle{750, 50, 100, 65},
		render_info = DEBUG_BUTTON_RENDER_INFO,
		state = .UP,
		sprite_id = .CURSOR_UP,
	},
	.HARVEST_BUTTON = {
		rect = rl.Rectangle{860, 50, 100, 65},
		render_info = DEBUG_BUTTON_RENDER_INFO,
		state = .UP,
		sprite_id = .HARVEST_TOOL,
	},
	.SEED_BUTTON_CARROT = {
		rect = rl.Rectangle{750, 125, 100, 65},
		render_info = DEBUG_BUTTON_RENDER_INFO,
		state = .UP,
		sprite_id = .CARROT_SEED_BAG,
	},
}


GAME_UI_BUTTON_ACTIONS: [GameUIButtonID]ButtonCallback = {
	.CURSOR_BUTTON = proc(button: ^UIButton, game_data: ^GameData) {
		game_data.tool_id = .CURSOR
	},
	.SEED_BUTTON_CARROT = proc(button: ^UIButton, game_data: ^GameData) {
		game_data.tool_id = .SEED_CARROT
	},
	.HARVEST_BUTTON = proc(button: ^UIButton, game_data: ^GameData) {
		game_data.tool_id = .HARVEST_TOOL
	},
}


