const std = @import("std");

pub fn lines(alloc: std.mem.Allocator, str: []const u8) ![][]const u8 {
	var length: usize = 1;
	for (str) |char| {
		if (char == '\n')
			length += 1;
	}
	var toReturn: [][]const u8 = try alloc.alloc([]const u8, length);

	var start: usize = 0;
	var i: usize = 0;
	for (str) |char, idx| {
		if (char == '\n') {
			toReturn[i] = str[start..idx :'\n'];
			start = idx + 1;
			i += 1;
		}
	}
	toReturn[i] = str[start..str.len];

	return toReturn;
}

pub fn trim(str: []const u8) []const u8 {
	var start: usize = std.math.maxInt(usize);
	var end: usize = 0;

	for (str) |char, i| {
		if (
			!(char == ' ' or char == '\n' or char == '\t' or char == '\r') and start == std.math.maxInt(usize)
		) {
			start = i;
			end = i;
		} else if (!(char == ' ' or char == '\n' or char == '\t' or char == '\r'))
			end = i;
	}

	return str[start..end + 1];
}

pub fn find(char: u8, many: usize, str: []const u8) ?usize {
	if (many == 0) @panic("find expects many > 0");

	var cnt: usize = many;

	for (str) |other, i| {
		if (char == other and cnt == 1)
			return i
		else if (char == other)
			cnt -= 1;
	}
	return null;
}
