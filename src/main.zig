const std = @import("std");
const advent_of_zig = @import("advent_of_zig");

const print = std.debug.print;

pub fn main() !void {
    print("Progress:\n", .{});
    print("- [x] Day 01\n" ++
        "  - [x] Part 1\n" ++
        "  - [x] Part 2\n" ++
        "- [x] Day 02\n" ++
        "  - [x] Part 1\n" ++
        "  - [x] Part 2\n" ++
        "- [x] Day 03\n" ++
        "  - [x] Part 1\n" ++
        "  - [x] Part 2\n" ++
        "- [ ] Day 04\n" ++
        "- [ ] Day 05\n" ++
        "- [ ] Day 06\n" ++
        "- [ ] Day 07\n" ++
        "- [ ] Day 08\n" ++
        "- [ ] Day 09\n" ++
        "- [ ] Day 10\n" ++
        "- [ ] Day 11\n" ++
        "- [ ] Day 12\n", .{});

    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();
    //const alloc = gpa.allocator();

    //const input = try std.fs.cwd().readFileAlloc(alloc, "day03.txt", 69420);
    //defer alloc.free(input);

    //print("result: {}\n", .{advent_of_zig.day03.part2(input) catch unreachable});
}
