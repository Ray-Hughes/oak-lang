const std = @import("std");
const lexer = @import("lexer.zig");
const parser = @import("parser.zig");
const interpreter = @import("interpreter.zig");

pub fn repl() !void {
    const allocator = std.heap.page_allocator;
    const stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    while (true) {
        try stdout.print("> ", .{});
        const line = try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n');
        const tokens = try lexer.tokenize(line);
        var ast = parser.parse(tokens);
        _ = interpreter.interpret(&ast);
        allocator.free(line);
    }
}
