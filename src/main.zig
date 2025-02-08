const std = @import("std");
const Lexer = @import("compiler/lexer.zig").Lexer;
const Token = @import("compiler/token.zig").Token;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("Usage: oakc <source file>\n", .{});
        return;
    }

    const filename = args[1];
    std.debug.print("Compiling: {s}\n", .{filename});

    var file = try std.fs.cwd().openFile(filename, .{});

    defer file.close();

    const file_size = try file.getEndPos();
    const source = try allocator.alloc(u8, file_size);
    defer allocator.free(source);

    var lexer = Lexer.init(source);
    while (true) {
        const token = lexer.nextToken();
        std.debug.print("{s}: {s}\n", .{ @tagName(token.token_type), token.lexeme });
        if (token.token_type == .EOF) break;
    }
}
