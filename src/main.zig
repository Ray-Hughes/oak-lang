//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

const std = @import("std");
const lib = @import("oak-lang_lib");
const lexer = @import("lexer.zig");
const parser = @import("parser.zig");
const interpreter = @import("interpreter.zig");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    var stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    var allocator = std.heap.page_allocator;
    const stdin = std.io.getStdIn().reader();

    while (true) {
        try stdout.print("> ", .{});
        const line = try stdin.readUntilDelimiterOrEofAlloc(&allocator, '\n');
        const tokens = try lexer.tokenize(line);
        var ast = parser.parse(tokens);
        _ = interpreter.interpret(&ast);
        allocator.free(line);
    }

    try bw.flush(); // Don't forget to flush!
}

test "lexer test" {
    const input = "a = 1 + 2";
    const tokens = try lexer.tokenize(input);

    try std.testing.expectEqual(tokens.len, 6); // Update to expect 6 tokens including EOF
    try std.testing.expectEqual(tokens[0].typ, lexer.TokenType.Identifier);
    try std.testing.expectEqual(tokens[1].typ, lexer.TokenType.Equals);
    try std.testing.expectEqual(tokens[2].typ, lexer.TokenType.Number);
    try std.testing.expectEqual(tokens[3].typ, lexer.TokenType.Plus);
    try std.testing.expectEqual(tokens[4].typ, lexer.TokenType.Number);
    try std.testing.expectEqual(tokens[5].typ, lexer.TokenType.EOF);
}

test "parser test" {
    const input = "a = 1 + 2";
    const tokens = try lexer.tokenize(input);

    const ast = parser.parse(tokens);
    _ = ast;
    // Add assertions to check the structure of the AST
}

test "interpreter test" {
    const input = "a = 1 + 2";
    const tokens = try lexer.tokenize(input);

    var ast = parser.parse(tokens);
    _ = interpreter.interpret(&ast);
    // Add assertions to check the result of the interpretation
}
