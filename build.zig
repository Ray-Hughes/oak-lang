const std = @import("std");

pub fn build(b: *std.Build) void {
    const mode = b.release_mode;
    const target = b.standardTargetOptions(.{});
    const test_step = b.step("test", "Run unit tests");

    const test_repl = b.addTest(.{
        .root_source_file = b.path("test/repl_test.zig"),
        .target = b.resolveTargetQuery(target),
    });
    const run_unit_tests = b.addRunArtifact(test_repl);
    test_step.dependOn(&run_unit_tests.step);

    // const test_parser = b.addTest("test/parser_test.zig");
    // test_parser.setBuildMode(mode);
    // test_parser.setTarget(target);

    // const test_lexer = b.addTest("test/lexer_test.zig");
    // test_lexer.setBuildMode(mode);
    // test_lexer.setTarget(target);

    // const test_interpreter = b.addTest("test/interpreter_test.zig");
    // test_interpreter.setBuildMode(mode);
    // test_interpreter.setTarget(target);

    // const test_main = b.addTest("src/main.zig");
    // test_main.setBuildMode(mode);
    // test_main.setTarget(target);

    const exe = b.addExecutable("oak-lang", "src/main.zig");
    exe.setBuildMode(mode);
    exe.setTarget(target);
    exe.install();
}
