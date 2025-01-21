const std = @import("std");
const lexer = @import("../src/lexer.zig");
const parser = @import("../src/parser.zig");

test "parser test" {
    const input = "a = 1 + 2";
    const tokens = try lexer.tokenize(input);

    const ast = parser.parse(tokens);
    _ = ast;
    // Add assertions to check the structure of the AST
}
