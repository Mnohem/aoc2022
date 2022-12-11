const std = @import("std");
const fmt = std.fmt;

const aoc = @import("zig-helper");

const input = @embedFile("input/day6");

pub fn main() !void {
	// var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	// defer arena.deinit();
	// const aa = arena.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch unreachable;

	const inputLines = aoc.trim(input);

    try stdout.print("Day 6 Part 1: {?d}\n", .{day6(inputLines, 4)});
    try stdout.print("Day 6 Part 2: {?d}\n", .{day6(inputLines, 14)});
}

fn day6(inputLines: []const u8, messageLength: usize) ?usize {
	var i: usize = 0;
	outer: while (i < inputLines.len - 4) : (i += 1) {
		const sub = inputLines[i..i + messageLength];

		for (sub) |char, j| {
			for (sub[j + 1..]) |other| {
				if (char == other) continue :outer;
			}
		}
		return i + messageLength;
	}

	return null;
}
