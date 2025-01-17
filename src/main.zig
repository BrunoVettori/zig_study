const std = @import("std");
const zap = @import("zap");

fn on_request(r: zap.Request) void {
    if (r.path) |the_path| {
        std.debug.print("PATH: {s}\n", .{the_path});
    }

    if (r.query) |the_query| {
        std.debug.print("QUERY: {s}\n", .{the_query});
    }

    const file = @embedFile("pages/index.html");

    const allocator = std.heap.page_allocator;

    const size = std.mem.replacementSize(u8, file, "{{this}}", "that");
    const output = allocator.alloc(u8, size) catch return;
    _ = std.mem.replace(u8, file, "{{this}}", "that", output);

    r.sendBody(output) catch return;
}

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 3000,
        .on_request = on_request,
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
