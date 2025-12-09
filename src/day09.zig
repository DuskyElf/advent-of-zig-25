const std = @import("std");
const math = std.math;
const mem = std.mem;
const fmt = std.fmt;

const Pair = struct {
    x: i64,
    y: i64,
};

pub fn area(a: Pair, b: Pair) u64 {
    return @abs(a.x - b.x + 1) * @abs(a.y - b.y + 1);
}

pub fn part1(input: []const u8) !u64 {
    const row_count = mem.count(u8, mem.trim(u8, input, "\n"), "\n") + 1;

    const sysalloc = std.heap.page_allocator;
    var pairs = try std.ArrayList(Pair).initCapacity(sysalloc, row_count);
    defer pairs.deinit(sysalloc);

    var lines = mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |pair| {
        var pair_it = mem.tokenizeScalar(u8, pair, ',');
        const first: i64 = @intCast(try fmt.parseInt(u64, pair_it.next() orelse return error.Invalid, 10));
        const second: i64 = @intCast(try fmt.parseInt(u64, pair_it.next() orelse return error.Invalid, 10));
        pairs.appendAssumeCapacity(.{ .x = first, .y = second });
    }

    var max_area: u64 = 0;
    for (0..pairs.items.len) |i| {
        for (i..pairs.items.len) |j| {
            if (i == j) continue;

            const a = area(pairs.items[i], pairs.items[j]);
            if (a > max_area) {
                max_area = a;
            }
        }
    }

    return max_area;
}

