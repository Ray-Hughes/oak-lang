const std = @import("std");

pub fn repl() !void {
    const allocator = std.heap.page_allocator;
    const stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    while (true) {
        try stdout.print("> ", .{});
        var line = try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n');
        const tokens = try tokenize(line, allocator);
        const ast = parse(tokens);
        interpret(ast);
        allocator.free(line);
    }
}
