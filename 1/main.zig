const std = @import("std");
const fs = std.fs;

pub fn main() !void {
    var result: u32 = 0;
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
    while (reader.streamUntilDelimiter(writer, '\n', null)) {
        defer line.clearRetainingCapacity();
        const nums = readLine(line.items);
        result += nums[0] + nums[1];

        //std.debug.print("line: {s}\n", .{line.items});
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }
    std.debug.print("Result: {d}\n", .{result});
}

fn readLine(line: []u8) [2]u8 {
    var nums_in_line: [10]u8 = undefined;
    var idx: u8 = 0;
    const nums = [10]u8{ 48, 49, 50, 51, 52, 53, 54, 55, 56, 57 };
    for (line) |char| {
        for (nums) |num| {
            if (char == num) {
                nums_in_line[idx] = char - 48;
                idx += 1;
            }
        }
    }

    var result = [2]u8{ 0, 0 };

    result[0] = nums_in_line[0] * 10;
    if (nums_in_line.len > 1) {
        result[1] = nums_in_line[idx - 1];
    }

    std.debug.print("{d}", .{result});

    return result;
}
