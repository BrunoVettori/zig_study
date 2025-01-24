const std = @import("std");
const zap = @import("zap");

pub fn index(req: zap.Request) void {
    const file = @embedFile("../pages/index.html");
    const top_bar = @embedFile("../components/top_bar.html");

    const size = std.mem.replacementSize(u8, file, "{{top_bar}}", top_bar);

    const allocator = std.heap.page_allocator;
    const output = allocator.alloc(u8, size) catch return;
    defer allocator.free(output);

    _ = std.mem.replace(u8, file, "{{top_bar}}", top_bar, output);

    req.sendBody(output) catch return;
}
