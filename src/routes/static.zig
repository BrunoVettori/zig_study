const pool = @import("../database/pool.zig");
const std = @import("std");
const zap = @import("zap");

pub fn static(req: zap.Request) void {
    const file = @embedFile("../pages/static.html");

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

    req.sendBody(file) catch return;
}
