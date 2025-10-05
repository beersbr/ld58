package ld58

import "core:container/queue"
import "core:fmt"

Pool :: struct($T: typeid) {
	capacity:  u32,
	items:     [dynamic]T,
	free_list: queue.Queue(u32),
	used_list: queue.Queue(u32),
}


pool_init :: proc(pool: ^Pool($T), capacity: u32) {
	assert(capacity != 0)

	pool.capacity = capacity
	pool.items = make([dynamic]T, capacity, capacity)

	queue.init(&pool.free_list, cast(int)capacity)
	queue.init(&pool.used_list, cast(int)capacity)

	for i in (0 ..< capacity) {
		queue.push_back(&pool.free_list, i)
	}

}

pool_get_at :: proc(pool: ^Pool($T), idx: u32) -> ^T {
	item_index := queue.get(&pool.used_list, idx)
	if idx < pool.capacity {
		return &(pool.items[item_index])
	}
	return nil
}

pool_acquire :: proc(pool: ^Pool($T)) -> (bool, ^T) {
	if queue.len(pool.free_list) == 0 {return false, nil}

	free_item_index := queue.pop_back(&pool.free_list)
	queue.push_front(&pool.used_list, free_item_index)
	result: ^T = &pool.items[free_item_index]

	return true, result
}

pool_release :: proc(pool: ^Pool($T), item: ^T) {

}
