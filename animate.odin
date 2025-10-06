package ld58

import "core:container/queue"
import rl "vendor:raylib"

DEFAULT_ANIMTION_SYSTEM_CAPACITY :: 1000

// EasingFunction :: proc(t: f32, b: $T, c: $T, d: f32)
EasingFunction :: proc(t: f32, b: f32, c: f32, d: f32) -> f32

EasingFunctionID :: enum {
	EaseLinearNone,
	EaseLinearIn,
	EaseLinearOut,
	EaseLinearInOut,
	EaseSineIn,
	EaseSineOut,
	EaseSineInOut,
	EaseCircIn,
	EaseCircOut,
	EaseCircInOut,
	EaseCubicIn,
	EaseCubicOut,
	EaseCubicInOut,
	EaseQuadIn,
	EaseQuadOut,
	EaseQuadInOut,
	EaseExpoIn,
	EaseExpoOut,
	EaseExpoInOut,
	EaseBackIn,
	EaseBackOut,
	EaseBackInOut,
	EaseBounceOut,
	EaseBounceIn,
	EaseBounceInOut,
	EaseElasticIn,
	EaseElasticOut,
	EaseElasticInOut,
}

EASING_FUNCTIONS: [EasingFunctionID]EasingFunction = {
	.EaseLinearNone   = rl.EaseLinearNone,
	.EaseLinearIn     = rl.EaseLinearIn,
	.EaseLinearOut    = rl.EaseLinearOut,
	.EaseLinearInOut  = rl.EaseLinearInOut,
	.EaseSineIn       = rl.EaseSineIn,
	.EaseSineOut      = rl.EaseSineOut,
	.EaseSineInOut    = rl.EaseSineInOut,
	.EaseCircIn       = rl.EaseCircIn,
	.EaseCircOut      = rl.EaseCircOut,
	.EaseCircInOut    = rl.EaseCircInOut,
	.EaseCubicIn      = rl.EaseCubicIn,
	.EaseCubicOut     = rl.EaseCubicOut,
	.EaseCubicInOut   = rl.EaseCubicInOut,
	.EaseQuadIn       = rl.EaseQuadIn,
	.EaseQuadOut      = rl.EaseQuadOut,
	.EaseQuadInOut    = rl.EaseQuadInOut,
	.EaseExpoIn       = rl.EaseExpoIn,
	.EaseExpoOut      = rl.EaseExpoOut,
	.EaseExpoInOut    = rl.EaseExpoInOut,
	.EaseBackIn       = rl.EaseBackIn,
	.EaseBackOut      = rl.EaseBackOut,
	.EaseBackInOut    = rl.EaseBackInOut,
	.EaseBounceOut    = rl.EaseBounceOut,
	.EaseBounceIn     = rl.EaseBounceIn,
	.EaseBounceInOut  = rl.EaseBounceInOut,
	.EaseElasticIn    = rl.EaseElasticIn,
	.EaseElasticOut   = rl.EaseElasticOut,
	.EaseElasticInOut = rl.EaseElasticInOut,
}

AnimationTarget :: union {
	f32,
}

Animation :: struct {
	target:     ^AnimationTarget,
	start:      AnimationTarget,
	end:        AnimationTarget,
	duration:   f64,
	start_time: f64,
	fn_id:      EasingFunctionID,
}


AnimationSystem :: struct {
	animations: queue.Queue(Animation),
}
//
//
// animsys_init :: proc(system: ^AnimationSystem, capacity: i32 = DEFAULT_ANIMTION_SYSTEM_CAPACITY) {
// 	queue.init(&system.animations, cast(int)capacity)
// }
//
//
// animsys_start :: proc(system: ^AnimationSystem, anim: Animation) {
// 	anim.start_time = rl.GetTime()
// 	queue.push_back(system.animations, anim)
// }
//
// animsys_update :: proc(system: ^AnimationSystem, dt: f32) {
//
// 		
// }
