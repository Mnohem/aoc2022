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

    try stdout.print("Day 5 Part 1: {d}\n", .{try day4_p1(inputLines)});
    try stdout.print("Day 5 Part 2: {d}\n", .{try day4_p2(inputLines)});
}

fn day4_p1(inputLines: [][]const u8) !usize {
	_ = inputLines;
	return 0;
}

fn day4_p2(inputLines: [][]const u8) !usize {
	_ = inputLines;
	return 0;
}
