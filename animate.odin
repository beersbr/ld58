package ld58

import "core:container/queue"
import "core:fmt"
import "core:math"
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
	// NOTE: this this should be replaced by an "effect" or something that wraps a bunch of
	// connected animations
	Wobble,
}

EASING_FUNCTIONS: [EasingFunctionID]EasingFunction = {
	.EaseLinearNone = rl.EaseLinearNone,
	.EaseLinearIn = rl.EaseLinearIn,
	.EaseLinearOut = rl.EaseLinearOut,
	.EaseLinearInOut = rl.EaseLinearInOut,
	.EaseSineIn = rl.EaseSineIn,
	.EaseSineOut = rl.EaseSineOut,
	.EaseSineInOut = rl.EaseSineInOut,
	.EaseCircIn = rl.EaseCircIn,
	.EaseCircOut = rl.EaseCircOut,
	.EaseCircInOut = rl.EaseCircInOut,
	.EaseCubicIn = rl.EaseCubicIn,
	.EaseCubicOut = rl.EaseCubicOut,
	.EaseCubicInOut = rl.EaseCubicInOut,
	.EaseQuadIn = rl.EaseQuadIn,
	.EaseQuadOut = rl.EaseQuadOut,
	.EaseQuadInOut = rl.EaseQuadInOut,
	.EaseExpoIn = rl.EaseExpoIn,
	.EaseExpoOut = rl.EaseExpoOut,
	.EaseExpoInOut = rl.EaseExpoInOut,
	.EaseBackIn = rl.EaseBackIn,
	.EaseBackOut = rl.EaseBackOut,
	.EaseBackInOut = rl.EaseBackInOut,
	.EaseBounceOut = rl.EaseBounceOut,
	.EaseBounceIn = rl.EaseBounceIn,
	.EaseBounceInOut = rl.EaseBounceInOut,
	.EaseElasticIn = rl.EaseElasticIn,
	.EaseElasticOut = rl.EaseElasticOut,
	.EaseElasticInOut = rl.EaseElasticInOut,
	.Wobble = proc(t: f32, b: f32, c: f32, d: f32) -> f32 {
		r := t / d
		return b + (-math.sin(2 * math.PI * r) * 10.0)
	},
}

AnimationTarget :: union {
	^f32,
	f32,
	^v2f,
	v2f,
}

Animation :: struct {
	system_tag: i32,
	target:     AnimationTarget,
	start:      AnimationTarget,
	end:        AnimationTarget,
	delta:      AnimationTarget,
	duration:   f32,
	start_time: f32,
	fn_id:      EasingFunctionID,
}

AnimationSystem :: struct {
	initialized: bool,
	pool:        Pool(Animation),
	active:      queue.Queue(^Animation),
}

@(private = "file")
ANIMATION_SYSTEMS: map[i32]^AnimationSystem = nil
ANIMATION_SYSTEMS_MEMORY: [dynamic]AnimationSystem

@(private = "file")
ANIMATION_SYSTEM_INITIALIZED: bool = false

@(private = "file")
MAX_ANIMATION_SYSTEMS :: 8

@(private = "file")
TOTAL_ANIMATION_SYSTEMS := 0

DEFAULT_ANIMATION_SYSTEM_TAG :: -100

animation_system_init :: proc() {
	ANIMATION_SYSTEM_INITIALIZED: bool = false
	ANIMATION_SYSTEMS_MEMORY = make([dynamic]AnimationSystem, 8)
	ANIMATION_SYSTEMS = make(map[i32]^AnimationSystem, 8)

	animation_system_create(DEFAULT_ANIMATION_SYSTEM_TAG)
}

animation_system_create :: proc(tag: i32, capacity: i32 = DEFAULT_ANIMTION_SYSTEM_CAPACITY) {

	assert((TOTAL_ANIMATION_SYSTEMS + 1) < MAX_ANIMATION_SYSTEMS)
	ANIMATION_SYSTEMS[tag] = &ANIMATION_SYSTEMS_MEMORY[TOTAL_ANIMATION_SYSTEMS]

	system := ANIMATION_SYSTEMS[tag]

	pool_init(&system.pool, cast(u32)capacity)
	queue.init(&system.active, cast(int)capacity)
	system.initialized = true

	TOTAL_ANIMATION_SYSTEMS += 1
}

anim_new :: proc(tag: i32 = DEFAULT_ANIMATION_SYSTEM_TAG) -> ^Animation {
	system: ^AnimationSystem = ANIMATION_SYSTEMS[tag]
	assert(system.initialized)
	ok, anim := pool_acquire(&system.pool)
	anim.system_tag = tag

	return anim
}

anim_start :: proc(anim: ^Animation) {
	anim.start_time = cast(f32)rl.GetTime()
	system: ^AnimationSystem = ANIMATION_SYSTEMS[anim.system_tag]
	anim.delta = anim.end.(f32) - anim.start.(f32)
	queue.push_back(&system.active, anim)
}

animation_system_update :: proc(dt: f32, tag: i32 = DEFAULT_ANIMATION_SYSTEM_TAG) {

	system: ^AnimationSystem = ANIMATION_SYSTEMS[tag]

	ct: f32 = cast(f32)rl.GetTime()

	for i in 0 ..< queue.len(system.active) {
		anim: ^Animation = queue.get(&system.active, i)
		t: f32 = math.clamp(ct - anim.start_time, 0, anim.duration)
		fn: EasingFunction = EASING_FUNCTIONS[anim.fn_id]

		#partial switch target in anim.target {
		case ^f32:
			anim.target.(^f32)^ = fn(t, anim.start.(f32), anim.delta.(f32), anim.duration)
		// case ^v2f:
		// 	anim.target.(^v2f)^ = fn(t, anim.start.(v2f), anim.delta.(v2f), anim.duration)
		case:
		}
	}
}
