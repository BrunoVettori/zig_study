const std = @import("std");
const zap = @import("zap");

fn router(request: zap.Request) void {
    const path: []const u8 = request.path orelse "/";

    if (std.mem.eql(u8, path, "/")) {
        const country: []const u8 = request.query orelse "";

        const file = @embedFile("pages/index.html");

        const allocator = std.heap.page_allocator;

        const size = std.mem.replacementSize(u8, file, "{{country}}", country);
        const output = allocator.alloc(u8, size) catch return;
        _ = std.mem.replace(u8, file, "{{country}}", country, output);

        defer allocator.free(output);

        request.sendBody(output) catch return;
    }

    if (std.mem.eql(u8, path, "/futebol")) {
        const file = @embedFile("pages/futebol.html");

        request.sendBody(file) catch return;
    }
}

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 3000,
        .on_request = router,
        .log = true,
    });

    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:3000\n", .{});

    // start worker threads
    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}
