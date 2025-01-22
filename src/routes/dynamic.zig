const std = @import("std");
const zap = @import("zap");

var count: i32 = 0;

pub fn dynamic(req: zap.Request) void {
    count = count + 1;

    var b: [10]u8 = undefined;

    const string_count = std.fmt.bufPrint(&b, "{d}", .{count}) catch return;

    std.debug.print("{s}\n", .{&string_count});

    const file = @embedFile("../pages/dynamic.html");
    const size = std.mem.replacementSize(u8, file, "{{count}}", string_count);

    const allocator = std.heap.page_allocator;
    const output = allocator.alloc(u8, size) catch return;
    defer allocator.free(output);

    _ = std.mem.replace(u8, file, "{{count}}", string_count, output);

    req.sendBody(output) catch return;
}
