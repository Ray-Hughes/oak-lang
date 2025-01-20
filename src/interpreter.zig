const std = @import("std");
const Node = @import("parser.zig").Node;
const NodeType = @import("parser.zig").NodeType;

pub fn interpret(node: *Node) i32 {
    switch (node.typ) {
        .BinaryOp => {
            const left_value = interpret(node.left.?);
            const right_value = interpret(node.right.?);
            return switch (node.value[0]) {
                '+' => left_value + right_value,
                '-' => left_value - right_value,
                '*' => left_value * right_value,
                '/' => left_value / right_value,
                else => @panic("Unknown operator"),
            };
        },
        .Number => {
            return std.fmt.parseInt(i32, node.value, 10) catch @panic("Invalid number");
        },
        .Identifier => {
            // For simplicity, return a fixed value for identifiers
            return 0;
        },
    }
}
