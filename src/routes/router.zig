const std = @import("std");
const zap = @import("zap");

const index = @import("./index.zig");
const static = @import("./static.zig").static;
const dynamic = @import("./dynamic.zig").dynamic;

var routes: std.StringHashMap(zap.HttpRequestFn) = undefined;

pub fn setup_routes(alloc: std.mem.Allocator) !void {
    routes = std.StringHashMap(zap.HttpRequestFn).init(alloc);
    try routes.put("/static", static);
    try routes.put("/dynamic", dynamic);
}

pub fn route(req: zap.Request) void {
    if (req.path) |the_path| {
        if (routes.get(the_path)) |route_function| {
            route_function(req);
            return;
        }
    }

    const file = @embedFile("../pages/index.html");
    req.sendBody(file) catch return;
}
