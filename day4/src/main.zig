const std = @import("std");
const fmt = std.fmt;

const aoc = @import("zig-helper");

const input = @embedFile("input/day4");

pub fn main() !void {
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const aa = arena.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch unreachable;

	const inputLines = try aoc.lines(aa, aoc.trim(input));

    try stdout.print("Day 4 Part 1: {d}\n", .{try day4_p1(inputLines)});
    try stdout.print("Day 4 Part 2: {d}\n", .{try day4_p2(inputLines)});
}

fn day4_p1(inputLines: [][]const u8) !usize {
	var toReturn: usize = 0;

	for (inputLines) |line| {
		var set1: [2]usize = undefined;
		var set2: [2]usize = undefined;

		const firstDashIdx = aoc.find('-', 1, line).?;
		const secondDashIdx = aoc.find('-', 2, line).?;
		const commaIdx = aoc.find(',', 1, line).?;

		set1[0] = try 
			fmt.parseUnsigned(usize, line[0..firstDashIdx], 10);
		set1[1] = try 
			fmt.parseUnsigned(usize, line[firstDashIdx + 1..commaIdx], 10);

		set2[0] = try 
			fmt.parseUnsigned(usize, line[commaIdx + 1..secondDashIdx], 10);
		set2[1] = try 
			fmt.parseUnsigned(usize, line[secondDashIdx + 1..], 10);

		const isFullOverlap = (set1[0] <= set2[0] and set1[1] >= set2[1])
			or (set1[0] >= set2[0] and set1[1] <= set2[1]);

		if (isFullOverlap)
			toReturn += 1;
	}

	return toReturn;
}

fn day4_p2(inputLines: [][]const u8) !usize {
	var toReturn: usize = 0;

	for (inputLines) |line| {
		var set1: [2]usize = undefined;
		var set2: [2]usize = undefined;

		const firstDashIdx = aoc.find('-', 1, line).?;
		const secondDashIdx = aoc.find('-', 2, line).?;
		const commaIdx = aoc.find(',', 1, line).?;

		set1[0] = try 
			fmt.parseUnsigned(usize, line[0..firstDashIdx], 10);
		set1[1] = try 
			fmt.parseUnsigned(usize, line[firstDashIdx + 1..commaIdx], 10);

		set2[0] = try 
			fmt.parseUnsigned(usize, line[commaIdx + 1..secondDashIdx], 10);
		set2[1] = try 
			fmt.parseUnsigned(usize, line[secondDashIdx + 1..], 10);

		const isFullOverlap = (set1[0] <= set2[0] and set1[1] >= set2[0])
			or (set1[0] >= set2[0] and set1[0] <= set2[1]);

		if (isFullOverlap)
			toReturn += 1;
	}

	return toReturn;
}
