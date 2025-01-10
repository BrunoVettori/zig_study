const std = @import("std");

const formater = @import("./utils.zig");

// pub const User = struct {
//     power: u64,
//     name: []const u8,

//     pub fn diagnose(user: User) void {
//         if (user.power >= 8000) {
//             std.debug.print("{s} porwe is {d}\n", .{ user.name, user.power });
//         }
//     }
// };

pub fn main() !void {
    // var user = User{ .power = 8999, .name = "Bruno" };

    // user.name = "Alex";

    // user.diagnose();

    var value: f64 = 0;

    value = value + 10;

    value = value / 3;

    value = formater.FormatDecimals(value, "2");

    std.debug.print("{d}\n", .{value});
}
