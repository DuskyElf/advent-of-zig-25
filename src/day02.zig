const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn part1(input: []const u8) !u64 {
    var result: u64 = 0;

    var pairs = mem.tokenizeAny(u8, input, ",\n ");
    while (pairs.next()) |pair| {
        var pair_it = mem.tokenizeAny(u8, pair, "-\n ");

        const start = try fmt.parseInt(u64, pair_it.next() orelse return error.InvalidPair, 10);
        const end = try fmt.parseInt(u64, pair_it.next() orelse return error.InvalidPair, 10);

        for (start..end + 1) |num| {
            var num_str_buf: [20]u8 = undefined;
            const num_str = try fmt.bufPrint(&num_str_buf, "{}", .{num});

            const left = num_str[0 .. num_str.len / 2];
            const right = num_str[num_str.len / 2 .. num_str.len];

            if (mem.eql(u8, left, right)) {
                result += @intCast(num);
            }
        }
    }

    return result;
}

pub fn part2(input: []const u8) !u64 {
    var result: u64 = 0;

    var pairs = mem.tokenizeAny(u8, input, ",\n ");
    while (pairs.next()) |pair| {
        var pair_it = mem.tokenizeAny(u8, pair, "-\n ");

        const start = try fmt.parseInt(u64, pair_it.next() orelse return error.InvalidPair, 10);
        const end = try fmt.parseInt(u64, pair_it.next() orelse return error.InvalidPair, 10);

        for (start..end + 1) |num| {
            var num_str_buf: [20]u8 = undefined;
            const num_str = try fmt.bufPrint(&num_str_buf, "{}", .{num});

            for (1..@divFloor(num_str.len, 2) + 1) |i| {
                if (@mod(num_str.len, i) != 0) continue;

                var j = i;
                const first = num_str[0..i];
                while (j < num_str.len) : (j += i) {
                    const part = num_str[j .. j + i];
                    if (!mem.eql(u8, first, part)) {
                        break;
                    }
                } else {
                    result += @intCast(num);
                    break;
                }
            }
        }
    }

    return result;
}
