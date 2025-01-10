const std = @import("std");

pub fn FormatDecimals(number: f64, places: []const u8) f64 {
    var buf: [32]u8 = undefined;

    const parse_places = "{d:." ++ places ++ "}";

    const formatted = std.fmt.bufPrint(&buf, parse_places, .{number}) catch unreachable;

    const float = try std.fmt.parseFloat(f64, formatted);

    return float;
}
