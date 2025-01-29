const pool = @import("../database/pool.zig");
const std = @import("std");
const zap = @import("zap");

pub fn static(req: zap.Request) void {
    const layout = @embedFile("../pages/layouts/main.html");
    const file = @embedFile("../pages/static.html");

    const size = std.mem.replacementSize(u8, layout, "{{content}}", file);

    const allocator = std.heap.page_allocator;
    const output = allocator.alloc(u8, size) catch return;
    defer allocator.free(output);

    _ = std.mem.replace(u8, layout, "{{content}}", file, output);

    var result = pool.pool.query("select id, name, hoes from test", .{}) catch return;
    defer result.deinit();

    while (true) {
        const row = result.next() catch break;

        if (row) |row_value| {
            const id = row_value.get(i32, 0);
            // this is only valid until the next call to next(), deinit() or drain()
            const name = row_value.get([]u8, 1);

            const hoes = row_value.get(i32, 2);

            std.debug.print("{d} - {s} - {d}\n", .{ id, name, hoes });
        } else {
            break;
        }
    }

    req.sendBody(output) catch return;
}
