const router = @import("./routes/router.zig");
const pool = @import("./database/pool.zig");
const std = @import("std");
const zap = @import("zap");

pub fn main() !void {
    pool.init_pool(std.heap.page_allocator) catch return;

    try router.setup_routes(std.heap.page_allocator);

    var listener = zap.HttpListener.init(.{
        .port = 3000,
        .on_request = router.route,
        .log = true,
        .public_folder = "./public",
    });

    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:3000\n", .{});

    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}
