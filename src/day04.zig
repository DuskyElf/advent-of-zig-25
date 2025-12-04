const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn part1(input: []const u8) !u64 {
    var result: u64 = 0;

    const row_size = mem.indexOfScalar(u8, input, '\n').?;
    const stride = row_size + 1; // including newline
    const row_count = input.len / stride;

    for (0..row_count) |r| {
        for (0..row_size) |c| {
            const val = input[r * stride + c];
            if (val != '@') continue;

            var neighbors: u8 = 0;

            var dr: isize = -1;
            while (dr <= 1) : (dr += 1) {
                var dc: isize = -1;
                while (dc <= 1) : (dc += 1) {
                    if (dr == 0 and dc == 0) continue;

                    const i = @as(isize, @intCast(r)) + dr;
                    const j = @as(isize, @intCast(c)) + dc;
                    if (i >= 0 and i < @as(isize, @intCast(row_count)) and
                        j >= 0 and j < @as(isize, @intCast(row_size)))
                    {
                        const neighbor_val = input[@as(usize, @intCast(i)) * stride + @as(usize, @intCast(j))];
                        if (neighbor_val == '@') {
                            neighbors += 1;
                        }
                    }
                }
            }

            if (neighbors < 4) {
                result += 1;
            }
        }
    }

    return result;
}

pub fn part2(input: []const u8) !u64 {
    var result: u64 = 0;

    const row_size = mem.indexOfScalar(u8, input, '\n').?;
    const row_count = input.len / (row_size + 1); // including newline

    const sysalloc = std.heap.page_allocator;

    var grid = try std.ArrayList(u8).initCapacity(sysalloc, row_count * row_size);
    defer grid.deinit(sysalloc);

    {
        var lines = mem.tokenizeScalar(u8, input, '\n');
        while (lines.next()) |line| {
            grid.appendSliceAssumeCapacity(line);
        }
    }

    var changes: bool = true;
    while (changes) {
        changes = false;
        for (0..row_count) |r| {
            for (0..row_size) |c| {
                const val = grid.items[r * row_size + c];
                if (val != '@') continue;
                var neighbors: u8 = 0;
                var dr: isize = -1;
                while (dr <= 1) : (dr += 1) {
                    var dc: isize = -1;
                    while (dc <= 1) : (dc += 1) {
                        if (dr == 0 and dc == 0) continue;
                        const i = @as(isize, @intCast(r)) + dr;
                        const j = @as(isize, @intCast(c)) + dc;
                        if (i >= 0 and i < @as(isize, @intCast(row_count)) and
                            j >= 0 and j < @as(isize, @intCast(row_size)))
                        {
                            const neighbor_val = grid.items[@as(usize, @intCast(i)) * row_size + @as(usize, @intCast(j))];
                            if (neighbor_val == '@') {
                                neighbors += 1;
                            }
                        }
                    }
                }

                if (neighbors < 4) {
                    grid.items[r * row_size + c] = '.';
                    changes = true;
                    result += 1;
                }
            }
        }
    }

    return result;
}
