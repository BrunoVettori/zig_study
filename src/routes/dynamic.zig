const std = @import("std");
const zap = @import("zap");

var count: i32 = 0;

fn attachLayout(file: []u8, allocator: std.mem.Allocator) []u8 {
    const layout = @embedFile("../pages/layouts/main.html");

    const size = std.mem.replacementSize(u8, layout, "{{content}}", file);

    const output = allocator.alloc(u8, size) catch return file;

    _ = std.mem.replace(u8, layout, "{{content}}", file, output);

    return output;
}

pub fn dynamic(req: zap.Request) void {
    count = count + 1;

    var b: [10]u8 = undefined;

    const string_count = std.fmt.bufPrint(&b, "{d}", .{count}) catch return;

    const file = @embedFile("../pages/dynamic.html");
    const size = std.mem.replacementSize(u8, file, "{{count}}", string_count);

    const allocator = std.heap.page_allocator;
    const output = allocator.alloc(u8, size) catch return;
    defer allocator.free(output);

    _ = std.mem.replace(u8, file, "{{count}}", string_count, output);

    const page = attachLayout(output, allocator);

    defer allocator.free(page);

    req.sendBody(page) catch return;
}
