const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn part1(input: []const u8) !u64 {
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

    for (0..row_count) |r| {
        for (0..row_size) |c| {
            switch (grid.items[r * row_size + c]) {
                'S' => {
                    if (r + 1 < row_count) {
                        if (grid.items[(r + 1) * row_size + c] == '.') {
                            grid.items[(r + 1) * row_size + c] = '|';
                        }
                    }
                },
                '|' => {
                    if (r + 1 < row_count) {
                        switch (grid.items[(r + 1) * row_size + c]) {
                            '.' => {
                                grid.items[(r + 1) * row_size + c] = '|';
                            },
                            '^' => {
                                if (c > 0) {
                                    grid.items[(r + 1) * row_size + c - 1] = '|';
                                }
                                if (c < row_size - 1) {
                                    grid.items[(r + 1) * row_size + c + 1] = '|';
                                }
                                result += 1;
                            },
                            '|' => {},
                            else => unreachable,
                        }
                    }
                },
                '.' => {},
                '^' => {},
                else => unreachable,
            }
        }
    }

    return result;
}

pub fn part2(input: []const u8) !u64 {
    var result: u64 = 0;

    const row_size = mem.indexOfScalar(u8, input, '\n').?;
    const stride = row_size + 1; // including newline
    const row_count = input.len / stride;

    const sysalloc = std.heap.page_allocator;
    var memo = try std.ArrayList(u64).initCapacity(sysalloc, row_count * row_size);
    defer memo.deinit(sysalloc);
    memo.appendNTimesAssumeCapacity(0, row_count * row_size);

    const idx = mem.indexOfScalar(u8, input, 'S').?;
    const r = idx / stride;
    const c = idx % stride;
    result += explore(input, stride, row_size, row_count, r + 1, c, memo.items);

    return result + 1;
}

fn explore(grid: []const u8, stride: usize, row_size: usize, row_count: usize, r: usize, c: usize, memo: []u64) u64 {
    if (memo[r * row_size + c] != 0) {
        return memo[r * row_size + c];
    }

    switch (grid[r * stride + c]) {
        '.' => {
            if (r >= row_count - 1) {
                return 0;
            }
            const result = explore(grid, stride, row_size, row_count, r + 1, c, memo);
            memo[r * row_size + c] = result;
            return result;
        },
        '^' => {
            var result: u64 = 1;

            if (c > 0) {
                result += explore(grid, stride, row_size, row_count, r + 1, c - 1, memo);
            }
            if (c < row_size - 1) {
                result += explore(grid, stride, row_size, row_count, r + 1, c + 1, memo);
            }

            memo[r * row_size + c] = result;
            return result;
        },
        else => unreachable,
    }
}
