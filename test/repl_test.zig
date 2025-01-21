const std = @import("std");
const lexer = @import("../src/lexer.zig");
const parser = @import("../src/parser.zig");
const interpreter = @import("../src/interpreter.zig");

test "repl test with addition" {
    const input = "1 + 2\n";
    const tokens = try lexer.tokenize(input);
    var ast = parser.parse(tokens);
    const result = interpreter.interpret(&ast);
    try std.testing.expectEqual(result, 3);
}

test "repl test with subtraction" {
    const input = "5 - 3\n";
    const tokens = try lexer.tokenize(input);
    var ast = parser.parse(tokens);
    const result = interpreter.interpret(&ast);
    try std.testing.expectEqual(result, 2);
}

test "repl test with multiplication" {
    const input = "4 * 2\n";
    const tokens = try lexer.tokenize(input);
    var ast = parser.parse(tokens);
    const result = interpreter.interpret(&ast);
    try std.testing.expectEqual(result, 8);
}

test "repl test with division" {
    const input = "8 / 2\n";
    const tokens = try lexer.tokenize(input);
    var ast = parser.parse(tokens);
    const result = interpreter.interpret(&ast);
    try std.testing.expectEqual(result, 4);
}
