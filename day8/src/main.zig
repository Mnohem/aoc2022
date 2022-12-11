const std = @import("std");
const fmt = std.fmt;

const aoc = @import("zig-helper");

const input = @embedFile("input/day8");
// const input =
// 	\\30373
// 	\\25512
// 	\\65332
// 	\\33549
// 	\\35390
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

    try stdout.print("Day 8 Part 1: {!d}\n", .{day8_p1(aa, inputLines)});
    try stdout.print("Day 8 Part 2: {!d}\n", .{day8_p2(inputLines)});
}
	
	
fn day8_p1(alloc: std.mem.Allocator, inputLines: [][]const u8) !usize {
	const n = inputLines.len; // The input is nxn
	var visibleTrees = std.AutoHashMap(struct{usize, usize}, u8).init(alloc);

	var i: usize = 0;
	while (i < n) : (i += 1) {
		var topTree = inputLines[0][i] - '0';
		try visibleTrees.put(.{0, i}, topTree);

		var j: usize = 1;
		while (j < n) : (j += 1) {
			// std.debug.print("topTree {d}:\n", .{i});
			const nextTree = inputLines[j][i] - '0';
			if (topTree < nextTree) {
				// std.debug.print("{d} is visible at ({d}, {d})\n", .{nextTree, j, i});
				try visibleTrees.put(.{j, i}, nextTree);
				topTree = nextTree;
			}
		}

		var bottomTree = inputLines[n - 1][i] - '0';
		try visibleTrees.put(.{n - 1, i}, bottomTree);
		
		j = 1;
		while (j < n) : (j += 1) {
			// std.debug.print("bottomTree {d}:\n", .{i});
			const nextTree = inputLines[n - 1 - j][i] - '0';
			if (bottomTree < nextTree) {
				// std.debug.print("{d} is visible at ({d}, {d})\n", .{nextTree, n - 1 - j, i});
				try visibleTrees.put(.{n - 1 - j, i}, nextTree);
				bottomTree = nextTree;
			}
		}

		var leftTree = inputLines[i][0] - '0';
		try visibleTrees.put(.{i, 0}, leftTree);

		j = 1;
		while (j < n) : (j += 1) {
			// std.debug.print("leftTree {d}:\n", .{i});
			const nextTree = inputLines[i][j] - '0';
			if (leftTree < nextTree) {
				// std.debug.print("{d} is visible at ({d}, {d})\n", .{nextTree, i, j});
				try visibleTrees.put(.{i, j}, nextTree);
				leftTree = nextTree;
			}
		}

		var rightTree = inputLines[i][n - 1] - '0';
		try visibleTrees.put(.{i, n - 1}, rightTree);

		j = 1;
		while (j < n) : (j += 1) {
			// std.debug.print("rightTree {d}:\n", .{i});
			const nextTree = inputLines[i][n - 1 - j] - '0';
			if (rightTree < nextTree) {
				// std.debug.print("{d} is visible at ({d}, {d})\n", .{nextTree, i, n - 1 - j});
				try visibleTrees.put(.{i, n - 1 - j}, nextTree);
				rightTree = nextTree;
			}
		}
	}

	return visibleTrees.count();
}

fn day8_p2(inputLines: [][]const u8) !usize {
	const n = inputLines.len; // The input is nxn

	var bestScenicScore: usize = 0;

	for (inputLines) |line, row| {
		for (line) |num, column| {
			const height = num - '0';

			const visibleTreesUp = up: {
				var visible: usize = 0;
				var i: isize = @intCast(isize, row) - 1;
				while (i >= 0) : (i -= 1) {
					const nextHeight = inputLines[@intCast(usize, i)][column] - '0';
					if (height > nextHeight)
						visible += 1
					else
						break :up visible + 1;
				} else
					break :up visible;
			};
			const visibleTreesDown = down: {
				var visible: usize = 0;
				var i: usize = row + 1;
				while (i < n) : (i += 1) {
					const nextHeight = inputLines[i][column] - '0';
					if (height > nextHeight)
						visible += 1
					else
						break :down visible + 1;
				} else
					break :down visible;
			};
			const visibleTreesLeft = left: {
				var visible: usize = 0;
				var i: isize = @intCast(isize, column) - 1;
				while (i >= 0) : (i -= 1) {
					const nextHeight = inputLines[row][@intCast(usize, i)] - '0';
					if (height > nextHeight)
						visible += 1
					else
						break :left visible + 1;
				} else
					break :left visible;
			};
			const visibleTreesRight = right: {
				var visible: usize = 0;
				var i: usize = column + 1;
				while (i < n) : (i += 1) {
					const nextHeight = inputLines[row][i] - '0';
					if (height > nextHeight)
						visible += 1
					else
						break :right visible + 1;
				} else
					break :right visible;
			};

			const currScenicScore = visibleTreesDown * visibleTreesUp * visibleTreesRight * visibleTreesLeft;

			if (bestScenicScore < currScenicScore)
				bestScenicScore = currScenicScore;
		}
	}

	return bestScenicScore;
}
