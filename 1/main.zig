const std = @import("std");
const fs = std.fs;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile("./calibration.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    const writer = line.writer();
    var line_no: usize = 1;
    while (reader.streamUntilDelimiter(writer, '\n', null)) : (line_no += 1) {
        defer line.clearRetainingCapacity();

        std.debug.print("line number: {d} - line: {s}\n", .{ line_no, line.items });
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }
}

fn readLine(reader: anytype, buffer: []u8) ![]const u8 {
    const line = try reader.readUntilDelimiterOrEof(buffer, '\n');
    return line;
}
