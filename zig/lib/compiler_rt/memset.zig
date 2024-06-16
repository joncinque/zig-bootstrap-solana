const std = @import("std");
const common = @import("./common.zig");
const builtin = @import("builtin");

comptime {
    if (builtin.object_format != .c) {
        if (builtin.os.tag == .solana) {
            const Syscall = struct {
                extern fn sol_memset_(dest: ?[*]u8, c: u8, len: usize) callconv(.C) ?[*]u8;
                pub fn sol_memset(dest: ?[*]u8, c: u8, len: usize) callconv(.C) ?[*]u8 {
                    return sol_memset_(dest, c, len);
                }
            };
            @export(Syscall.sol_memset, .{ .name = "memset", .linkage = common.linkage, .visibility = common.visibility });
        } else {
            @export(memset, .{ .name = "memset", .linkage = common.linkage, .visibility = common.visibility });
        }
        @export(__memset, .{ .name = "__memset", .linkage = common.linkage, .visibility = common.visibility });
    }
}

pub fn memset(dest: ?[*]u8, c: u8, len: usize) callconv(.C) ?[*]u8 {
    @setRuntimeSafety(false);

    if (len != 0) {
        var d = dest.?;
        var n = len;
        while (true) {
            d[0] = c;
            n -= 1;
            if (n == 0) break;
            d += 1;
        }
    }

    return dest;
}

pub fn __memset(dest: ?[*]u8, c: u8, n: usize, dest_n: usize) callconv(.C) ?[*]u8 {
    if (dest_n < n)
        @panic("buffer overflow");
    return memset(dest, c, n);
}
