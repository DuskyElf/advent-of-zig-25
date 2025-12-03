const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn part1(input: []const u8) !u64 {
    var result: u64 = 0;

    var lines = mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const left_i = mem.indexOfMax(u8, line[0 .. line.len - 1]);
        const right_i = mem.indexOfMax(u8, line[left_i + 1 .. line.len]) + left_i + 1;
        result += (line[left_i] - '0') * 10 + (line[right_i] - '0');
    }

    return result;
}

pub fn part2(input: []const u8) !u64 {
    var result: u64 = 0;

    var lines = mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var number_str: [12]u8 = undefined;

        var l: usize = 0;
        var r = line.len - 12;
        for (0..12) |i| {
            if (l == r + 1) {
                mem.copyForwards(u8, number_str[i..], line[l..]);
                break;
            }

            const max_i = mem.indexOfMax(u8, line[l .. r + 1]) + l;
            number_str[i] = line[max_i];
            l = max_i + 1;
            r += 1;
        }

        result += try fmt.parseInt(u64, &number_str, 10);
    }

    return result;
}
