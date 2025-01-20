const std = @import("std");
const zap = @import("zap");

const router = @import("./routes/router.zig");

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 3005,
        .on_request = router.route,
        .log = true,
    });

    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:3005\n", .{});

    // start worker threads
    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}
