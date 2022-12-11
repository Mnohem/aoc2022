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

pub fn find(el: anytype, many: usize, slice: []const @TypeOf(el)) ?usize {
	if (many == 0) @panic("find expects many > 0");

	var cnt: usize = many;

	for (slice) |other, i| {
		if (el == other and cnt == 1)
			return i
		else if (el == other)
			cnt -= 1;
	}
	return null;
}

test "find" {
	const str = "sdfasdfasdfff fsgfg ";
	try std.testing.expectEqual(find(@as(u8, ' '), 1, str), 13);
	try std.testing.expectEqual(find(@as(u8, ' '), 2, str), str.len - 1);
}

pub fn findPat(comptime T: type, pat: []const T, many: usize, slice: []const T) ?usize {
	if (many == 0) @panic("findPat expects many > 0");

	var cnt: usize = many;

	var i = pat.len;

	while (i <= slice.len) : (i += 1) {
		const sub = slice[i - pat.len..i];

		if (std.mem.eql(T, pat, sub) and cnt == 1)
			return i - pat.len
		else if (std.mem.eql(T, pat, sub))
			cnt -= 1;
	}
	return null;
}

test "findPat" {
	const str = "sdfasdfasdfff fsgfg";
	try std.testing.expectEqual(findPat(u8, "fff", 1, str), 10);
	try std.testing.expectEqual(findPat(u8, "fff", 2, str), null);
	try std.testing.expectEqual(findPat(u8, "sdf", 1, str), 0);
}
