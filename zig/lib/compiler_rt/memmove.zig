const std = @import("std");
const common = @import("./common.zig");
const builtin = @import("builtin");

comptime {
    if (builtin.os.tag == .solana) {
        const Syscall = struct {
            extern fn sol_memmove_(dest: ?[*]u8, src: ?[*]const u8, n: usize) callconv(.C) void;
            pub fn sol_memmove(dest: ?[*]u8, src: ?[*]const u8, n: usize) callconv(.C) ?[*]u8 {
                sol_memmove_(dest, src, n);
                return dest;
            }
        };
        @export(Syscall.sol_memmove, .{ .name = "memmove", .linkage = common.linkage, .visibility = common.visibility });
    } else {
        @export(memmove, .{ .name = "memmove", .linkage = common.linkage, .visibility = common.visibility });
    }
}

pub fn memmove(dest: ?[*]u8, src: ?[*]const u8, n: usize) callconv(.C) ?[*]u8 {
    @setRuntimeSafety(false);

    if (@intFromPtr(dest) < @intFromPtr(src)) {
        var index: usize = 0;
        while (index != n) : (index += 1) {
            dest.?[index] = src.?[index];
        }
    } else {
        var index = n;
        while (index != 0) {
            index -= 1;
            dest.?[index] = src.?[index];
        }
    }

    return dest;
}
