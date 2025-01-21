const std = @import("std");
const lexer = @import("../src/lexer.zig");

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
