const std = @import("std");
const pg = @import("pg");

pub var pool: *pg.Pool = undefined;

pub fn init_pool(allocator: std.mem.Allocator) !void {
    pool = try pg.Pool.init(allocator, .{ .size = 10, .connect = .{
        .port = 5432,
        .host = "127.0.0.1",
    }, .auth = .{
        .username = "user",
        .database = "zig_study",
        .password = "password",
        .timeout = 10_000,
    } });
}

pub fn close_pool() void {
    pool.deinit();
}
