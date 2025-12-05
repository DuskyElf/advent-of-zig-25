const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const Pair = struct {
    start: u64,
    end: u64,
};

pub fn part1(input: []const u8) !u64 {
    var result: u64 = 0;

    const sysalloc = std.heap.page_allocator;
    const size = mem.indexOf(u8, input, "\n\n") orelse return error.Invalid;
    var pairs = try std.ArrayList(Pair).initCapacity(sysalloc, size);
    defer pairs.deinit(sysalloc);

    var lines = mem.splitScalar(u8, input, '\n');
    while (lines.next()) |pair| {
        if (pair.len == 0) break;

        var pair_it = mem.tokenizeAny(u8, pair, "-\n ");
        const start = try fmt.parseInt(u64, pair_it.next() orelse return error.Invalid, 10);
        const end = try fmt.parseInt(u64, pair_it.next() orelse return error.Invalid, 10);
        try pairs.append(sysalloc, Pair{ .start = start, .end = end });
    }

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const id = try fmt.parseInt(u64, line, 10);
        for (pairs.items) |pair| {
            if (id >= pair.start and id <= pair.end) {
                result += 1;
                break;
            }
        }
    }

    return result;
}

fn pair_less_than(_: @TypeOf(.{}), a: Pair, b: Pair) bool {
    if (a.start != b.start) {
        return a.start < b.start;
    }
    return a.end < b.end;
}

pub fn part2(input: []const u8) !u64 {
    var result: u64 = 0;

    const sysalloc = std.heap.page_allocator;
    const size = mem.indexOf(u8, input, "\n\n") orelse return error.Invalid;
    var pairs = try std.ArrayList(Pair).initCapacity(sysalloc, size);
    defer pairs.deinit(sysalloc);

    var lines = mem.splitScalar(u8, input, '\n');
    while (lines.next()) |pair| {
        if (pair.len == 0) break;

        var pair_it = mem.tokenizeAny(u8, pair, "-\n ");
        const start = try fmt.parseInt(u64, pair_it.next() orelse return error.Invalid, 10);
        const end = try fmt.parseInt(u64, pair_it.next() orelse return error.Invalid, 10);
        pairs.appendAssumeCapacity(.{ .start = start, .end = end });
    }

    mem.sort(Pair, pairs.items, .{}, pair_less_than);

    var last: ?Pair = null;
    for (pairs.items) |pair| {
        if (last == null or last.?.end < pair.start) {
            result += pair.end - pair.start + 1;
            last = pair;
        } else if (pair.end > last.?.end) {
            result += pair.end - last.?.end;
            last = .{ .start = last.?.start, .end = pair.end };
        }
    }

    return result;
}
