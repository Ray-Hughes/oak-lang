const std = @import("std");
const TokenType = @import("lexer.zig").TokenType;
const Token = @import("lexer.zig").Token;

pub const NodeType = enum {
    BinaryOp,
    Number,
    Identifier,
};

pub const Node = struct {
    typ: NodeType,
    left: ?*Node,
    right: ?*Node,
    value: []const u8,
};

fn parseExpression(tokens: []Token, index: *usize) Node {
    var left = parsePrimary(tokens, index);

    while (index < tokens.len and tokens[index].typ == TokenType.Plus) {
        const op = tokens[index];
        index += 1;
        const right = parsePrimary(tokens, index);
        left = Node{
            .typ = NodeType.BinaryOp,
            .left = &left,
            .right = &right,
            .value = op.value,
        };
    }

    return left;
}

fn parsePrimary(tokens: []Token, index: *usize) Node {
    const token = tokens[index];
    index += 1;

    switch (token.typ) {
        TokenType.Identifier => return Node{
            .typ = NodeType.Identifier,
            .left = null,
            .right = null,
            .value = token.value,
        },
        TokenType.Number => return Node{
            .typ = NodeType.Number,
            .left = null,
            .right = null,
            .value = token.value,
        },
        else => return Node{
            .typ = NodeType.Identifier,
            .left = null,
            .right = null,
            .value = "error",
        },
    }
}

pub fn parse(tokens: []Token) Node {
    var index: usize = 0;
    return parseExpression(tokens, &index);
}
