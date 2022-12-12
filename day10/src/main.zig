const std = @import("std");
const fmt = std.fmt;

const aoc = @import("zig-helper");

const input = @embedFile("input/day10");

pub fn main() !void {
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const aa = arena.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch unreachable;

	const inputLines = try aoc.lines(aa, aoc.trim(input));

    try stdout.print("Day 10 Part 1: {!d}\n", .{day10_p1(inputLines)});
    try stdout.print("Day 10 Part 2: {!d}\n", .{day10_p2(aa, inputLines)});
}
	
fn day10_p1(inputLines: [][]const u8) !isize {
	var x: isize = 1;
	var cycle: isize = 0;
	var sum: isize = 0;

	for (inputLines) |line| {
		var toAdd: isize = 0;
		if (std.mem.startsWith(u8, line, "addx")) {
			toAdd = try fmt.parseInt(isize, line[5..], 10);
			cycle += 1;
			sum += if (@mod(cycle - 20, 40) == 0 and cycle <= 220)
				x * cycle else 0;
		}
		cycle += 1;
		sum += if (@mod(cycle - 20, 40) == 0 and cycle <= 220)
			x * cycle else 0;
		x += toAdd;
	}

	return sum;
}

fn day10_p2(alloc: std.mem.Allocator, inputLines: [][]const u8) !usize {
	_ = alloc;
	_ = inputLines;
	return 0;
}
