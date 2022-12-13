const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const math = std.math;

const aoc = @import("zig-helper");

const input = @embedFile("input/day11");
// const input = 
// \\Monkey 0:
// \\  Starting items: 79, 98
// \\  Operation: new = old * 19
// \\  Test: divisible by 23
// \\    If true: throw to monkey 2
// \\    If false: throw to monkey 3
// \\
// \\Monkey 1:
// \\  Starting items: 54, 65, 75, 74
// \\  Operation: new = old + 6
// \\  Test: divisible by 19
// \\    If true: throw to monkey 2
// \\    If false: throw to monkey 0
// \\
// \\Monkey 2:
// \\  Starting items: 79, 60, 97
// \\  Operation: new = old * old
// \\  Test: divisible by 13
// \\    If true: throw to monkey 1
// \\    If false: throw to monkey 3
// \\
// \\Monkey 3:
// \\  Starting items: 74
// \\  Operation: new = old + 3
// \\  Test: divisible by 17
// \\    If true: throw to monkey 0
// \\    If false: throw to monkey 1
// ;

pub fn main() !void {
	var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
	defer arena.deinit();
	const aa = arena.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    defer bw.flush() catch unreachable;

    // try stdout.print("Day 11 Part 1:\n{s}\n", .{try day11(aa, input, 20, 3)});
    try stdout.print("Day 11 Part 2:\n{s}\n", .{try day11(aa, input, 10000)});
}

const ModuloMap = struct {
	divisors: std.AutoHashMap(usize, usize), // Key is factor, value is power

	const keys: [9]usize = .{2, 3, 5, 7, 11, 13, 17, 19, 23};

	pub fn new(alloc: mem.Allocator, num: usize) !ModuloMap {
		var map = .{
			.divisors = std.AutoHashMap(usize, usize).init(alloc),
		};

		for (keys) |divisor| {
			try map.divisors.put(divisor, num % divisor);
		}

		return map;
	}

	pub fn add(self: *ModuloMap, num: usize) !void {
		for (keys) |divisor| {
			const old = self.divisors.get(divisor).?;
			const newModulo = (old + num) % divisor;
			try self.divisors.put(divisor, newModulo);
		}
	}

	pub fn mul(self: *ModuloMap, num: usize) !void {
		for (keys) |divisor| {
			const old = self.divisors.get(divisor).?;
			const newModulo = (old * num) % divisor;
			try self.divisors.put(divisor, newModulo);
		}
	}

	pub fn square(self: *ModuloMap) !void {
		for (keys) |divisor| {
			const old = self.divisors.get(divisor).?;
			const newModulo = (old * old) % divisor;
			try self.divisors.put(divisor, newModulo);
		}
	}
};

const TailQueue = std.TailQueue(ModuloMap);

const Monkey = struct {
	items: TailQueue,
	op: union(enum) { Mult: usize, Add: usize, Square: void },
	divisorTest: usize,
	trueTest: usize, // Index of monkey to throw to when divisor is valid
	falseTest: usize, // Index of monkey to throw to when divisor is invalid
	inspectCount: usize,
};

fn day11(alloc: std.mem.Allocator, rawInput: []const u8, rounds: usize) ![]const u8 {
	var monkeys = std.ArrayList(Monkey).init(alloc);
	var monkeySplit = mem.split(u8, rawInput, "\n\n");

	while (monkeySplit.next()) |m| {
		var monkey: Monkey = undefined;
		monkey.inspectCount = 0;
		monkey.items = .{};

		const monkeyLines = try aoc.lines(alloc, aoc.trim(m));

		for (monkeyLines) |line| {
			const contents = aoc.trim(line);

			if (mem.startsWith(u8, contents, "Starting items")) {
				const list = contents[16..];
				var sItems = mem.tokenize(u8, list, ", ");

				while (sItems.next()) |item| {
					const numItem = try fmt.parseUnsigned(usize, item, 10);

					var node = try alloc.create(TailQueue.Node);
					node.data = try ModuloMap.new(alloc, numItem);
					node.next = null;
					node.prev = null;

					monkey.items.append(node);
				}
			} else if (mem.startsWith(u8, contents, "Operation")) {
				monkey.op =
					if (fmt.parseUnsigned(usize, contents[23..], 10)) |num|
						if (contents[21] == '*')
							.{ .Mult = num }
						else .{ .Add = num }
					else |_| .{ .Square = {} };
			} else if (mem.startsWith(u8, contents, "Test")) {
				monkey.divisorTest = try fmt.parseUnsigned(usize, contents[19..], 10);
			} else if (mem.startsWith(u8, contents, "If true")) {
				monkey.trueTest = try fmt.parseUnsigned(usize, contents[25..], 10);
			} else if (mem.startsWith(u8, contents, "If false")) {
				monkey.falseTest = try fmt.parseUnsigned(usize, contents[26..], 10);
			}
		}

		try monkeys.append(monkey);
	}

	var round = rounds;
	while (round > 0) : (round -= 1) {
		for (monkeys.items) |*monkey| {
			while (monkey.items.popFirst()) |item| {
				var dataAddr = &item.data;

				try switch (monkey.op) {
					.Add => |num| dataAddr.add(num),
					.Mult => |num| dataAddr.mul(num),
					.Square => dataAddr.square(),
				};

				if (dataAddr.divisors.get(monkey.divisorTest).? == 0)
					monkeys.items[monkey.trueTest].items.append(item)
				else
					monkeys.items[monkey.falseTest].items.append(item);

				monkey.*.inspectCount += 1;
			}
		}
	}

	var inspections = std.ArrayList(u8).init(alloc);
	var w = inspections.writer();
	for (monkeys.items) |monkey, i| {
		try w.print("Monkey {d} inspected {d} times.\n", .{i, monkey.inspectCount});
	}

	return inspections.items;
}
