const std = @import("std");
const fmt = std.fmt;

const aoc = @import("zig-helper");

const input = @embedFile("input/day9");
// const input =
// 	\\R 4
// 	\\U 4
// 	\\L 3
// 	\\D 1
// 	\\R 4
// 	\\D 1
// 	\\L 5
// 	\\R 2
// ;


pub fn main() !void {
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const aa = arena.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch unreachable;

	const inputLines = try aoc.lines(aa, aoc.trim(input));

    try stdout.print("Day 9 Part 1: {!d}\n", .{day9_p1(aa, inputLines)});
    try stdout.print("Day 9 Part 2: {!d}\n", .{day9_p2(aa, inputLines)});
}
	
const Point = struct { x: isize, y: isize };
	
fn day9_p1(alloc: std.mem.Allocator, inputLines: [][]const u8) !usize {
	const start: Point = .{ .x = 0, .y = 0};
	var tailPoints = std.AutoHashMap(Point, void).init(alloc);
	try tailPoints.put(start, {});

	var tail = start;
	var head = start;

	for (inputLines) |line| {
		var headMove: Point = .{ .x = 0, .y = 0};

		if (std.mem.startsWith(u8, line, "R"))
			headMove.x += 1
		else if (std.mem.startsWith(u8, line, "L"))
			headMove.x -= 1
		else if (std.mem.startsWith(u8, line, "D"))
			headMove.y -= 1
		else if (std.mem.startsWith(u8, line, "U"))
			headMove.y += 1;

		var steps = try fmt.parseInt(usize, line[2..], 10);

		while (steps > 0) : (steps -= 1) {
			head = .{ .x = head.x + headMove.x, .y = head.y + headMove.y};
			
			tail = updateTail(head, tail);
			try tailPoints.put(tail, {});
		}
	}
	return tailPoints.count();
}

fn day9_p2(alloc: std.mem.Allocator, inputLines: [][]const u8) !usize {
	const start: Point = .{ .x = 0, .y = 0};
	var tailPoints = std.AutoHashMap(Point, void).init(alloc);
	try tailPoints.put(start, {});

	var tails: [9]Point = .{start} ** 9;
	var head = start;

	for (inputLines) |line| {
		var headMove: Point = .{ .x = 0, .y = 0};

		if (std.mem.startsWith(u8, line, "R"))
			headMove.x += 1
		else if (std.mem.startsWith(u8, line, "L"))
			headMove.x -= 1
		else if (std.mem.startsWith(u8, line, "D"))
			headMove.y -= 1
		else if (std.mem.startsWith(u8, line, "U"))
			headMove.y += 1;

		var steps = try fmt.parseInt(usize, line[2..], 10);

		while (steps > 0) : (steps -= 1) {
			head = .{ .x = head.x + headMove.x, .y = head.y + headMove.y};
			
			tails[0] = updateTail(head, tails[0]);
			var prevTail = tails[0];
			for (tails) |*tail| {
				tail.* = updateTail(prevTail, tail.*);
				prevTail = tail.*;
			}

			try tailPoints.put(tails[8], {});
		}
	}
	return tailPoints.count();
}

fn updateTail(head: Point, tail: Point) Point {
	var tailMove: Point = .{ .x = 0, .y = 0};
	const tailIsMoving = head.x - tail.x > 1 or head.x - tail.x < -1
		or head.y - tail.y > 1 or head.y - tail.y < -1;
	
	if (tailIsMoving and head.x > tail.x)
		tailMove.x += 1;
	if (tailIsMoving and head.x < tail.x)
		tailMove.x -= 1;
	if (tailIsMoving and head.y > tail.y)
		tailMove.y += 1;
	if (tailIsMoving and head.y < tail.y)
		tailMove.y -= 1;

	return .{ .x = tail.x + tailMove.x, .y = tail.y + tailMove.y};
}
