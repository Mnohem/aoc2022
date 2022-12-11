const std = @import("std");
const fmt = std.fmt;

const aoc = @import("zig-helper");

const input = @embedFile("input/day7");

pub fn main() !void {
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const aa = arena.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch unreachable;

	const inputLines = try aoc.lines(aa, aoc.trim(input));

    try stdout.print("Day 7 Part 1: {!d}\n", .{day7_p1(aa, inputLines)});
    try stdout.print("Day 7 Part 2: {!d}\n", .{day7_p2(aa, inputLines)});
}

const File = union(enum) {
	Dir: struct { 
		name: []const u8,
		parent: ?*File,
		children: std.ArrayList(File),
		size: usize = 0,
	},
	File: usize,
};
	
	
fn day7_p1(alloc: std.mem.Allocator, inputLines: [][]const u8) !usize {
	const lines = inputLines[1..];

	var root: File = File {
		.Dir = .{
			.name = "/",
			.parent = null,
			.children = std.ArrayList(File).init(alloc),
		},
	};

	var cwd: *File = &root;

	for (lines) |line| {
		if (std.mem.startsWith(u8, line, "$ ")) {
			const command = line[2..];
			if (!std.mem.eql(u8, command, "ls")) {
				var split = std.mem.split(u8, command, " ");
				_ = split.next();

				const dirName = split.next().?;

				if (std.mem.eql(u8, dirName, ".."))
					cwd = cwd.*.Dir.parent.?
				else {
					for (cwd.*.Dir.children.items) |*child| {
						switch (child.*) {
							.Dir => |dir| {
								if (std.mem.eql(u8, dir.name, dirName))
									cwd = child;
							},
							else => {},
						}
					}
				}
			}
		} else if (std.mem.startsWith(u8, line, "dir ")){
			var newDir = File {
				.Dir = .{
					.name = line[4..],
					.parent = cwd,
					.children = std.ArrayList(File).init(alloc),
				},
			};

			try cwd.*.Dir.children.append(newDir);
		} else {
			const spaceIdx = aoc.find(@as(u8, ' '), 1, line).?;
			var file = File {
				.File = try std.fmt.parseInt(usize, line[0..spaceIdx], 10),
			};

			try cwd.*.Dir.children.append(file);
		}
	}

	_ = sizeOf(&root);

	var dirList = std.ArrayList(File).init(alloc);
	try dirList.append(root);

	var sum: usize = 0;

	while (dirList.popOrNull()) |dir| {
		sum += if (dir.Dir.size <= 100_000) dir.Dir.size else 0;

		for (dir.Dir.children.items) |child| {
			switch (child) {
				.Dir => try dirList.append(child),
				else => {},
			}
		}
	}

	return sum;
}

fn sizeOf(file: *File) usize {
	return switch (file.*) {
		.Dir => |*dir| sumChildren: {
			if (dir.*.size == 0) {
				var sum: usize = 0;
				for (dir.*.children.items) |*child| {
					sum += sizeOf(child);
				}
				dir.*.size = sum;
				break :sumChildren sum;
			} else {
				break :sumChildren dir.*.size;
			}
		},
		.File => |size| size,
	};
}

fn day7_p2(alloc: std.mem.Allocator, inputLines: [][]const u8) !usize {
	const lines = inputLines[1..];

	var root: File = File {
		.Dir = .{
			.name = "/",
			.parent = null,
			.children = std.ArrayList(File).init(alloc),
		},
	};

	var cwd: *File = &root;

	for (lines) |line| {
		if (std.mem.startsWith(u8, line, "$ ")) {
			const command = line[2..];
			if (!std.mem.eql(u8, command, "ls")) {
				var split = std.mem.split(u8, command, " ");
				_ = split.next();

				const dirName = split.next().?;

				if (std.mem.eql(u8, dirName, ".."))
					cwd = cwd.*.Dir.parent.?
				else {
					for (cwd.*.Dir.children.items) |*child| {
						switch (child.*) {
							.Dir => |dir| {
								if (std.mem.eql(u8, dir.name, dirName))
									cwd = child;
							},
							else => {},
						}
					}
				}
			}
		} else if (std.mem.startsWith(u8, line, "dir ")){
			var newDir = File {
				.Dir = .{
					.name = line[4..],
					.parent = cwd,
					.children = std.ArrayList(File).init(alloc),
				},
			};

			try cwd.*.Dir.children.append(newDir);
		} else {
			const spaceIdx = aoc.find(@as(u8, ' '), 1, line).?;
			var file = File {
				.File = try std.fmt.parseInt(usize, line[0..spaceIdx], 10),
			};

			try cwd.*.Dir.children.append(file);
		}
	}

	const totSize = sizeOf(&root);
	const unused = 70_000_000 - totSize;
	const neededSpace = 30_000_000 - unused;

	var dirList = std.ArrayList(File).init(alloc);
	try dirList.append(root);

	var toRemove: usize = sizeOf(&root);

	while (dirList.popOrNull()) |dir| {
		if (dir.Dir.size >= neededSpace and dir.Dir.size < toRemove)
			toRemove = dir.Dir.size;

		for (dir.Dir.children.items) |child| {
			switch (child) {
				.Dir => try dirList.append(child),
				else => {},
			}
		}
	}

	return toRemove;
}
