package ld58

import "core:container/queue"
import "core:fmt"
import "core:mem"
import "core:slice"

Pool :: struct($T: typeid) {
	capacity:  u32,
	items:     [dynamic]T,
	// free_list: queue.Queue(u32),
	// used_list: queue.Queue(u32),
	free_list: [dynamic]u32,
	used_list: [dynamic]u32,
}

pool_init :: proc(pool: ^Pool($T), capacity: u32) {
	assert(capacity != 0)

	pool.capacity = capacity
	pool.items = make([dynamic]T, capacity, capacity)

	pool.free_list = make([dynamic]u32, 0, capacity)
	pool.used_list = make([dynamic]u32, 0, capacity)
	for i in (0 ..< capacity) {
		append(&pool.free_list, i)
	}

	// queue.init(&pool.free_list, cast(int)capacity)
	// queue.init(&pool.used_list, cast(int)capacity)
	// for i in (0 ..< capacity) {
	// 	queue.push_back(&pool.free_list, i)
	// }
}

pool_get_at :: proc(pool: ^Pool($T), idx: u32) -> ^T {
	// item_index := queue.get(&pool.used_list, idx)

	item_index := pool.used_list[idx]

	// fmt.println(item_index)

	if idx < pool.capacity {
		return &(pool.items[item_index])
	}

	return nil
}

pool_acquire :: proc(pool: ^Pool($T)) -> (bool, ^T) {
	// if queue.len(pool.free_list) == 0 {return false, nil}
	// free_item_index := queue.pop_back(&pool.free_list)
	// queue.push_front(&pool.used_list, free_item_index)

	item_idx := pop(&pool.free_list)
	append(&pool.used_list, item_idx)

	result: ^T = &pool.items[item_idx]

	return true, result
}

pool_release :: proc(pool: ^Pool($T), item: ^T) {
	id: u32 = cast(u32)mem.ptr_sub(item, cast(^T)&pool.items[0])

	index, found := slice.linear_search(pool.used_list[:], id)

	unordered_remove(&pool.used_list, index)
	append(&pool.free_list, cast(u32)index)
}
