const std = @import("std");

pub fn part1(input: []const u8) u32 {
    var result: u32 = 0;
    var pointing: i32 = 50;

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const prefix = line[0];
        const value: i32 = @intCast(std.fmt.parseInt(u32, line[1..], 10) catch unreachable);

        switch (prefix) {
            'L' => {
                pointing = @mod(pointing - value, 100);
            },
            'R' => {
                pointing = @mod(pointing + value, 100);
            },
            else => {
                unreachable;
            },
        }

        if (pointing == 0) {
            result += 1;
        }
    }

    return result;
}

pub fn part2(input: []const u8) u32 {
    var result: u32 = 0;
    var pointing: i32 = 50;

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const prefix = line[0];
        const value: i32 = @intCast(std.fmt.parseInt(u32, line[1..], 10) catch unreachable);

        switch (prefix) {
            'L' => {
                const new_pointing = pointing - value;

                if (new_pointing == 0) {
                    result += 1;
                }
                // was pointing >= 0, so new less than zero means we crossed zero
                else if (new_pointing < 0) {
                    result += @abs(@divTrunc(new_pointing, 100)) + 1;

                    // except if we were already on zero,
                    // meaning we didn't cross it for the first time
                    if (pointing == 0) {
                        result -= 1;
                    }
                }

                pointing = @mod(new_pointing, 100);
            },
            'R' => {
                const new_pointing = pointing + value;

                if (new_pointing >= 100) {
                    result += @intCast(@divFloor(new_pointing, 100));
                }

                pointing = @mod(new_pointing, 100);
            },

            else => unreachable,
        }
    }

    return result;
}
