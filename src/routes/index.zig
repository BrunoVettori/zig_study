const std = @import("std");
const zap = @import("zap");

pub fn index(req: zap.Request) void {
    const layout = @embedFile("../pages/layouts/main.html");
    const file = @embedFile("../pages/index.html");

    const size = std.mem.replacementSize(u8, layout, "{{content}}", file);

    const allocator = std.heap.page_allocator;
    const output = allocator.alloc(u8, size) catch return;
    defer allocator.free(output);

    _ = std.mem.replace(u8, layout, "{{content}}", file, output);

    req.sendBody(output) catch return;
}
