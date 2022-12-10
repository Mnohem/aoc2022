const std = @import("std");
const fmt = std.fmt;

const aoc = @import("zig-helper");

const input = @embedFile("input/day5");

pub fn main() !void {
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const aa = arena.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch unreachable;

	const inputLines = try aoc.lines(aa, aoc.trim(input));
	std.mem.reverse([]const u8, inputLines[0..9]);

    try stdout.print("Day 5 Part 1: {!s}\n", .{day4_p1(aa, inputLines)});
    try stdout.print("Day 5 Part 2: {!s}\n", .{day4_p2(aa, inputLines)});
}

fn day4_p1(alloc: std.mem.Allocator, inputLines: [][]const u8) ![]const u8 {
	const TailQueue = std.TailQueue(u8);
		
	var stacks: [9]TailQueue = [_]TailQueue {.{}} ** 9;

	for (inputLines[0..9]) |array| {
		var i: usize = 0;
		var j: usize = 1;
		while (j < array.len) : ({j += 4; i += 1;}) {
			if (array[j] != ' ') {
				var node: *TailQueue.Node = try alloc.create(TailQueue.Node);
				node.data = array[j];
				node.next = null;
				node.prev = null;
					
				stacks[i].append(node);
			}
		}
	}

	for (inputLines[10..]) |line| {
		var split = std.mem.split(u8, line, " ");
		_ = split.next().?;
		var move = try fmt.parseInt(usize, split.next().?, 10);
		_ = split.next().?;
		const from = try fmt.parseInt(usize, split.next().?, 10);
		_ = split.next().?;
		const to = try fmt.parseInt(usize, split.next().?, 10);

		while (move > 0) : (move -= 1) {
			const node = stacks[from - 1].pop();
			stacks[to - 1].append(node.?);
		}
	}

	return fmt.allocPrint(alloc, "{c}" ** 9, .{
		stacks[0].pop().?.data,
		stacks[1].pop().?.data,
		stacks[2].pop().?.data,
		stacks[3].pop().?.data,
		stacks[4].pop().?.data,
		stacks[5].pop().?.data,
		stacks[6].pop().?.data,
		stacks[7].pop().?.data,
		stacks[8].pop().?.data,
	});
}

fn day4_p2(alloc: std.mem.Allocator, inputLines: [][]const u8) ![]const u8 {
	const TailQueue = std.TailQueue(u8);
		
	var stacks: [9]TailQueue = [_]TailQueue {.{}} ** 9;

	for (inputLines[0..9]) |array| {
		var i: usize = 0;
		var j: usize = 1;
		while (j < array.len) : ({j += 4; i += 1;}) {
			if (array[j] != ' ') {
				var node: *TailQueue.Node = try alloc.create(TailQueue.Node);
				node.data = array[j];
				node.next = null;
				node.prev = null;
					
				stacks[i].append(node);
			}
		}
	}

	for (inputLines[10..]) |line| {
		var split = std.mem.split(u8, line, " ");
		_ = split.next().?;
		var move = try fmt.parseInt(usize, split.next().?, 10);
		_ = split.next().?;
		const from = try fmt.parseInt(usize, split.next().?, 10);
		_ = split.next().?;
		const to = try fmt.parseInt(usize, split.next().?, 10);

		var tmpQueue: TailQueue = .{};
		while (move > 0) : (move -= 1) {
			var node = stacks[from - 1].pop();
			tmpQueue.prepend(node.?);
		}
		stacks[to - 1].concatByMoving(&tmpQueue);
	}

	return fmt.allocPrint(alloc, "{c}" ** 9, .{
		stacks[0].pop().?.data,
		stacks[1].pop().?.data,
		stacks[2].pop().?.data,
		stacks[3].pop().?.data,
		stacks[4].pop().?.data,
		stacks[5].pop().?.data,
		stacks[6].pop().?.data,
		stacks[7].pop().?.data,
		stacks[8].pop().?.data,
	});
}
