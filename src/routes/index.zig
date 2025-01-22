const zap = @import("zap");

pub fn index(req: zap.Request) void {
    const file = @embedFile("../pages/index.html");
    req.sendBody(file) catch return;
}
