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

    // Print file size before reading
    const file_size = try file.getEndPos();
    std.debug.print("File size: {}\n", .{file_size});

    // Read the file into memory
    const source = try file.readToEndAlloc(allocator, 1_000_000);
    defer allocator.free(source);

    // Print raw bytes of the file
    std.debug.print("Raw file bytes:\n", .{});
    for (source) |byte| {
        std.debug.print("{x} ", .{byte});
    }
    std.debug.print("\n", .{});

    // Pass source code to lexer
    var lexer = Lexer.init(source);
    while (true) {
        const token = lexer.nextToken();
        std.debug.print("{s}: {s}\n", .{ @tagName(token.token_type), token.lexeme });
        if (token.token_type == .EOF) break;
    }
}
