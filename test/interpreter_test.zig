const std = @import("std");
const lexer = @import("../src/lexer.zig");
const parser = @import("../src/parser.zig");
const interpreter = @import("../src/interpreter.zig");

test "interpreter test" {
    const input = "a = 1 + 2";
    const tokens = try lexer.tokenize(input);

    var ast = parser.parse(tokens);
    _ = interpreter.interpret(&ast);
    // Add assertions to check the result of the interpretation
}
