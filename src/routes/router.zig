const std = @import("std");
const zap = @import("zap");

pub fn route(request: zap.Request) void {
    const path: []const u8 = request.path orelse "/";

    if (std.mem.eql(u8, path, "/")) {
        const language: []const u8 = request.query orelse "";

        const file = @embedFile("../pages/index.html");

        const allocator = std.heap.page_allocator;

        const size = std.mem.replacementSize(u8, file, "{{language}}", language);
        const output = allocator.alloc(u8, size) catch return;
        _ = std.mem.replace(u8, file, "{{language}}", language, output);

        defer allocator.free(output);

        request.sendBody(output) catch return;
    }

    if (std.mem.eql(u8, path, "/front")) {
        const language: []const u8 = request.query orelse "";

        const file = @embedFile("../pages/front.html");

        const allocator = std.heap.page_allocator;

        const size = std.mem.replacementSize(u8, file, "{{language}}", language);
        const output = allocator.alloc(u8, size) catch return;
        _ = std.mem.replace(u8, file, "{{language}}", language, output);

        defer allocator.free(output);

        request.sendBody(output) catch return;
    }
}
