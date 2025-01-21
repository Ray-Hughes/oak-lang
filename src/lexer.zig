const std = @import("std");

pub const TokenType = enum {
    Identifier,
    Number,
    Plus,
    Minus,
    Star,
    Slash,
    Equals,
    LParen,
    RParen,
    EOF,
};

pub const Token = struct {
    typ: TokenType,
    value: []const u8,
};

pub fn tokenize(input: []const u8) ![]Token {
    var tokens = std.ArrayList(Token).init(std.heap.page_allocator);

    var i: usize = 0;

    while (i < input.len) {
        const c = input[i];

        if (std.ascii.isWhitespace(c)) {
            i += 1;
            continue;
        } else if (std.ascii.isAlphabetic(c)) {
            const start = i;
            while (i < input.len and std.ascii.isAlphanumeric(input[i])) : (i += 1) {}
            try tokens.append(Token{ .typ = .Identifier, .value = input[start..i] });
        } else if (std.ascii.isDigit(c)) {
            const start = i;
            while (i < input.len and std.ascii.isDigit(input[i])) : (i += 1) {}
            try tokens.append(Token{ .typ = .Number, .value = input[start..i] });
        } else switch (c) {
            '+' => {
                try tokens.append(Token{ .typ = .Plus, .value = "+" });
                i += 1;
            },
            '-' => {
                try tokens.append(Token{ .typ = .Minus, .value = "-" });
                i += 1;
            },
            '*' => {
                try tokens.append(Token{ .typ = .Star, .value = "*" });
                i += 1;
            },
            '/' => {
                try tokens.append(Token{ .typ = .Slash, .value = "/" });
                i += 1;
            },
            '=' => {
                try tokens.append(Token{ .typ = .Equals, .value = "=" });
                i += 1;
            },
            '(' => {
                try tokens.append(Token{ .typ = .LParen, .value = "(" });
                i += 1;
            },
            ')' => {
                try tokens.append(Token{ .typ = .RParen, .value = ")" });
                i += 1;
            },
            else => return error.InvalidToken,
        }
    }

    try tokens.append(Token{ .typ = .EOF, .value = "" });

    return tokens.toOwnedSlice();
}
