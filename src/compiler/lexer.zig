const std = @import("std");
const Token = @import("token.zig").Token;
const TokenType = @import("token.zig").TokenType;

pub const Lexer = struct {
    source: []const u8,
    position: usize = 0,
    line: usize = 1,

    pub fn init(source: []const u8) Lexer {
        return Lexer{ .source = source };
    }

    pub fn nextToken(self: *Lexer) Token {
        while (self.position < self.source.len) {
            const c = self.source[self.position];
            self.position += 1;

            switch (c) {
                ' ', '\t', '\r' => continue, // Ignore whitespace
                '\n' => {
                    self.line += 1;
                    continue;
                },
                '+' => return self.token(TokenType.Plus, "+"),
                '-' => return self.token(TokenType.Minus, "-"),
                '*' => return self.token(TokenType.Star, "*"),
                '/' => return self.token(TokenType.Slash, "/"),
                '(' => return self.token(TokenType.LeftParen, "("),
                ')' => return self.token(TokenType.RightParen, ")"),
                '{' => return self.token(TokenType.LeftBrace, "{"),
                '}' => return self.token(TokenType.RightBrace, "}"),
                ',' => return self.token(TokenType.Comma, ","),
                '.' => return self.token(TokenType.Dot, "."),
                ';' => return self.token(TokenType.Semicolon, ";"),
                '=' => {
                    if (self.match('=')) return self.token(TokenType.Equal, "==");
                    return self.token(TokenType.Assign, "=");
                },
                '!' => {
                    if (self.match('=')) return self.token(TokenType.NotEqual, "!=");
                    return self.token(TokenType.Invalid, "!");
                },
                '>' => {
                    if (self.match('=')) return self.token(TokenType.GreaterEqual, ">=");
                    return self.token(TokenType.Greater, ">");
                },
                '<' => {
                    if (self.match('=')) return self.token(TokenType.LessEqual, "<=");
                    return self.token(TokenType.Less, "<");
                },
                '"' => return self.stringToken(),
                else => {
                    if (std.ascii.isDigit(c)) return self.numberToken();
                    if (std.ascii.isAlphabetic(c) or c == '_') return self.identifierToken();
                    return self.token(TokenType.Invalid, &[_]u8{c});
                },
            }
        }
        return self.token(TokenType.EOF, "EOF");
    }

    fn match(self: *Lexer, expected: u8) bool {
        if (self.position < self.source.len and self.source[self.position] == expected) {
            self.position += 1;
            return true;
        }
        return false;
    }

    fn token(self: *Lexer, token_type: TokenType, lexeme: []const u8) Token {
        return Token{
            .token_type = token_type,
            .lexeme = lexeme,
            .line = self.line,
        };
    }

    fn numberToken(self: *Lexer) Token {
        const start = self.position - 1;
        while (self.position < self.source.len and std.ascii.isDigit(self.source[self.position])) {
            self.position += 1;
        }
        return self.token(TokenType.Number, self.source[start..self.position]);
    }

    fn identifierToken(self: *Lexer) Token {
        const start = self.position - 1;
        while (self.position < self.source.len and (std.ascii.isAlphanumeric(self.source[self.position]) or self.source[self.position] == '_')) {
            self.position += 1;
        }
        const lexeme = self.source[start..self.position];

        // Manually map keywords to their corresponding TokenType
        const keywords = [_]struct { []const u8, TokenType }{
            .{ "def", TokenType.Def },
            .{ "if", TokenType.If },
            .{ "else", TokenType.Else },
            .{ "return", TokenType.Return },
            .{ "while", TokenType.While },
            .{ "for", TokenType.For },
            .{ "true", TokenType.True },
            .{ "false", TokenType.False },
            .{ "nil", TokenType.Nil },
        };

        for (keywords) |kw| {
            if (std.mem.eql(u8, lexeme, kw[0])) {
                return self.token(kw[1], lexeme);
            }
        }

        return self.token(TokenType.Identifier, lexeme);
    }

    fn stringToken(self: *Lexer) Token {
        const start = self.position;
        while (self.position < self.source.len and self.source[self.position] != '"') {
            self.position += 1;
        }

        if (self.position >= self.source.len) {
            return self.token(TokenType.Invalid, self.source[start..self.position]);
        }

        self.position += 1; // Consume closing quote
        return self.token(TokenType.String, self.source[start .. self.position - 1]);
    }
};
