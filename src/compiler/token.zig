const std = @import("std");

pub const TokenType = enum {
    EOF, // End of file
    Identifier, // Variable names, function names
    Number, // Integer or floating point numbers
    String, // "Hello, World!"
    Keyword, // if, else, def, return, etc.
    Operator, // +, -, *, /, ==, !=, &&, ||, etc.
    Symbol, // Punctuation like ( ) { } , ; .

    // Keywords
    Def,
    If,
    Else,
    Return,
    While,
    For,
    True,
    False,
    Nil,

    // Operators
    Plus,
    Minus,
    Star,
    Slash,
    Assign,
    Equal,
    NotEqual,
    Greater,
    GreaterEqual,
    Less,
    LessEqual,

    // Punctuation
    LeftParen,
    RightParen,
    LeftBrace,
    RightBrace,
    Comma,
    Dot,
    Semicolon,

    Invalid, // Used for unknown characters
};

pub const Token = struct {
    token_type: TokenType,
    lexeme: []const u8, // The actual text of the token
    line: usize, // Line number for debugging
};
