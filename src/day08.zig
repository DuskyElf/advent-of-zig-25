const std = @import("std");
const math = std.math;
const mem = std.mem;
const fmt = std.fmt;

const Vec3 = @Vector(3, i64);

fn distance_squared(a: Vec3, b: Vec3) i64 {
    const c = (a - b) * (a - b); // i64 because of stupid integer underflow
    return c[0] + c[1] + c[2];
}

const Junction = struct {
    pos: Vec3,
    circuit_id: u16 = 0,
};

pub fn part1(input: []const u8) !u64 {
    var result: u64 = 1;

    const row_count = mem.count(u8, mem.trim(u8, input, "\n"), "\n") + 1;

    const sysalloc = std.heap.page_allocator;
    var junctions = std.MultiArrayList(Junction){};
    try junctions.ensureTotalCapacity(sysalloc, row_count);
    defer junctions.deinit(sysalloc);

    {
        var lines = mem.tokenizeScalar(u8, input, '\n');
        while (lines.next()) |line| {
            var nums = mem.tokenizeScalar(u8, line, ',');
            var v: Vec3 = .{ 0, 0, 0 };
            for (0..3) |i| {
                const num_str = nums.next().?;
                v[i] = @intCast(try fmt.parseInt(u64, num_str, 10));
            }
            junctions.appendAssumeCapacity(.{ .pos = v });
        }
    }

    var iota: u16 = 1; // for group ids
    const slice = junctions.slice();
    const poss = slice.items(.pos);
    var circuit_ids = slice.items(.circuit_id);

    var last_min: u64 = 0;

    //for (0..10) |_| { // for sample input
    for (0..1000) |_| { // for real input
        var min_a: usize = undefined;
        var min_b: usize = undefined;
        var min_yet: u64 = math.maxInt(u64);
        for (0..junctions.len) |i| {
            for (i..junctions.len) |j| {
                if (i != j) {
                    const dist = distance_squared(poss[i], poss[j]);
                    if (dist < min_yet and dist > last_min) {
                        min_yet = @intCast(dist);
                        min_a = i;
                        min_b = j;
                    }
                }
            }
        }

        last_min = min_yet;
        const prev_a = circuit_ids[min_a];
        const prev_b = circuit_ids[min_b];

        if (prev_a == 0 and prev_b == 0) {
            const cid = iota;
            iota += 1;
            circuit_ids[min_a] = cid;
            circuit_ids[min_b] = cid;
        } else if (prev_a == 0) {
            circuit_ids[min_a] = prev_b;
        } else if (prev_b == 0) {
            circuit_ids[min_b] = prev_a;
        } else {
            const cid = @min(prev_a, prev_b);
            const prev_cid = @max(prev_a, prev_b);
            mem.replaceScalar(u16, circuit_ids, prev_cid, cid);
        }
    }

    var freq_map = std.AutoHashMap(u16, u16).init(sysalloc);
    try freq_map.ensureTotalCapacity(@intCast(row_count));
    defer freq_map.deinit();

    var i: u32 = 0;
    for (circuit_ids) |pid| {
        const existing = freq_map.get(pid);
        if (existing) |val| {
            freq_map.putAssumeCapacity(pid, val + 1);
        } else {
            freq_map.putAssumeCapacity(pid, 1);
        }
        i += 1;
    }

    var top3: [3]u64 = .{ 0, 0, 0 };

    var it = freq_map.iterator();
    while (it.next()) |entry| {
        if (entry.key_ptr.* == 0) continue;
        const count = entry.value_ptr.*;

        for (0..top3.len) |t| {
            if (count > top3[t]) {
                var k = top3.len - 1;
                while (k > t) : (k -= 1) {
                    top3[k] = top3[k - 1];
                }
                top3[k] = count;
                break;
            }
        }
    }

    for (top3) |t| {
        if (t == 0) continue;
        result *= t;
    }

    return result;
}

pub fn part2(input: []const u8) !u64 {
    const row_count = mem.count(u8, mem.trim(u8, input, "\n"), "\n") + 1;

    const sysalloc = std.heap.page_allocator;
    var junctions = std.MultiArrayList(Junction){};
    try junctions.ensureTotalCapacity(sysalloc, row_count);
    {
        var lines = mem.tokenizeScalar(u8, input, '\n');
        while (lines.next()) |line| {
            var nums = mem.tokenizeScalar(u8, line, ',');
            var v: Vec3 = .{ 0, 0, 0 };
            for (0..3) |i| {
                const num_str = nums.next().?;
                v[i] = @intCast(try fmt.parseInt(u64, num_str, 10));
            }
            junctions.appendAssumeCapacity(.{ .pos = v });
        }
    }

    var iota: u16 = 1;
    const slice = junctions.slice();
    const poss = slice.items(.pos);
    var circuit_ids = slice.items(.circuit_id);

    var last_min: u64 = 0;
    var min_a: usize = undefined;
    var min_b: usize = undefined;
    while (true) {
        var min_yet: u64 = std.math.maxInt(u64);
        for (0..junctions.len) |i| {
            for (i..junctions.len) |j| {
                if (i != j) {
                    const dist = distance_squared(poss[i], poss[j]);
                    if (dist < min_yet and dist > last_min) {
                        min_yet = @intCast(dist);
                        min_a = i;
                        min_b = j;
                    }
                }
            }
        }

        last_min = min_yet;
        const prev_a = circuit_ids[min_a];
        const prev_b = circuit_ids[min_b];

        if (prev_a == 0 and prev_b == 0) {
            const cid = iota;
            iota += 1;
            circuit_ids[min_a] = cid;
            circuit_ids[min_b] = cid;
        } else if (prev_a == 0) {
            circuit_ids[min_a] = prev_b;
        } else if (prev_b == 0) {
            circuit_ids[min_b] = prev_a;
        } else {
            const cid = @min(prev_a, prev_b);
            const prev_cid = @max(prev_a, prev_b);
            mem.replaceScalar(u16, circuit_ids, prev_cid, cid);
        }

        const first_cid = circuit_ids[0];
        if (first_cid != 0) {
            var all_same = true;
            for (circuit_ids) |cid| {
                if (cid != first_cid) {
                    all_same = false;
                    break;
                }
            }
            if (all_same) {
                break;
            }
        }
    }

    return @intCast(poss[min_a][0] * poss[min_b][0]);
}
