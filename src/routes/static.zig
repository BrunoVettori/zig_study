const zap = @import("zap");

pub fn static(req: zap.Request) void {
    const file = @embedFile("../pages/static.html");
    req.sendBody(file) catch return;
}
