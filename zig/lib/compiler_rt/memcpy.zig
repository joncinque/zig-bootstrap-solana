const std = @import("std");
const common = @import("./common.zig");
const builtin = @import("builtin");

comptime {
    if (builtin.object_format != .c) {
        if (builtin.os.tag == .solana) {
            const Syscall = struct {
                extern fn sol_memcpy_(noalias dest: ?[*]u8, noalias src: ?[*]const u8, len: usize) callconv(.C) void;
                pub fn sol_memcpy(noalias dest: ?[*]u8, noalias src: ?[*]const u8, len: usize) callconv(.C) ?[*]u8 {
                    sol_memcpy_(dest, src, len);
                    return dest;
                }
            };
            @export(Syscall.sol_memcpy, .{ .name = "memcpy", .linkage = common.linkage, .visibility = common.visibility });
        } else {
            @export(memcpy, .{ .name = "memcpy", .linkage = common.linkage, .visibility = common.visibility });
        }
    }
}

pub fn memcpy(noalias dest: ?[*]u8, noalias src: ?[*]const u8, len: usize) callconv(.C) ?[*]u8 {
    @setRuntimeSafety(false);

    if (len != 0) {
        var d = dest.?;
        var s = src.?;
        var n = len;
        while (true) {
            d[0] = s[0];
            n -= 1;
            if (n == 0) break;
            d += 1;
            s += 1;
        }
    }

    return dest;
}
