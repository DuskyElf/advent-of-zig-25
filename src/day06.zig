const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn part1(input: []const u8) !u64 {
    var result: u64 = 0;

    const sysalloc = std.heap.page_allocator;
    var grid = std.ArrayList(u64){};
    defer grid.deinit(sysalloc);

    var operations_line: []const u8 = undefined;

    var row_size: ?u64 = null;
    var row_count: u64 = 0;
    var lines = mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const digits = mem.trimStart(u8, line, " ");
        if (digits[0] < '0' or digits[0] > '9') {
            operations_line = line;
            break;
        }

        var numbers = mem.tokenizeScalar(u8, digits, ' ');
        while (numbers.next()) |num| {
            const val = try fmt.parseInt(u64, num, 10);
            try grid.append(sysalloc, val);
        }

        if (row_size == null) {
            row_size = @as(u64, grid.items.len);
        }
        row_count += 1;
    }

    var operations = mem.tokenizeScalar(u8, operations_line, ' ');
    for (0..row_size.?) |c| {
        var inter_res: u64 = 0;
        const op = operations.next() orelse return error.Invalid;
        switch (op[0]) {
            '+' => {
                for (0..row_count) |r| {
                    const idx = r * row_size.? + c;
                    inter_res += grid.items[idx];
                }
            },
            '*' => {
                inter_res = 1;
                for (0..row_count) |r| {
                    const idx = r * row_size.? + c;
                    inter_res *= grid.items[idx];
                }
            },
            else => return error.Invalid,
        }

        result += inter_res;
    }

    return result;
}

pub fn part2(input: []const u8) !u64 {
    var result: u64 = 0;

    const row_size = mem.indexOfScalar(u8, input, '\n').?;
    const stride = row_size + 1; // including newline
    const row_count = input.len / stride;

    const sysalloc = std.heap.page_allocator;
    var numbers = try std.ArrayList(u64).initCapacity(sysalloc, 8);
    defer numbers.deinit(sysalloc);

    var operation: u8 = undefined;
    for (0..row_size) |c| {
        const col = row_size - 1 - c;

        var empty = true;
        var number: u64 = 0;
        for (0..row_count) |row| {
            const digit = input[row * stride + col];
            if (digit >= '0' and digit <= '9') {
                empty = false;
                number = number * 10 + @as(u64, digit - '0');
            } else if (digit == '+' or digit == '*') {
                operation = digit;
            }
        }

        if (!empty) {
            numbers.appendAssumeCapacity(number);
        } else {
            switch (operation) {
                '+' => {
                    var sum: u64 = 0;
                    for (numbers.items) |n| {
                        sum += n;
                    }
                    result += sum;
                },
                '*' => {
                    var product: u64 = 1;
                    for (numbers.items) |n| {
                        product *= n;
                    }
                    result += product;
                },
                else => return error.Invalid,
            }

            numbers.clearRetainingCapacity();
        }
    }

    if (numbers.items.len > 0) {
        switch (operation) {
            '+' => {
                var sum: u64 = 0;
                for (numbers.items) |n| {
                    sum += n;
                }
                result += sum;
            },
            '*' => {
                var product: u64 = 1;
                for (numbers.items) |n| {
                    product *= n;
                }
                result += product;
            },
            else => return error.Invalid,
        }
    }

    return result;
}
