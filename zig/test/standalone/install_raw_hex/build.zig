const Builder = @import("std").build.Builder;
const builtin = @import("builtin");
const std = @import("std");
const CheckFileStep = std.build.CheckFileStep;

pub fn build(b: *Builder) void {
    const target = .{
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
        .os_tag = .freestanding,
        .abi = .gnueabihf,
    };

    const mode = b.standardReleaseOptions();

    const elf = b.addExecutable("zig-nrf52-blink.elf", "main.zig");
    elf.setTarget(target);
    elf.setBuildMode(mode);

    const test_step = b.step("test", "Test the program");
    b.default_step.dependOn(test_step);

    const hex_step = b.addInstallRaw(elf, "hello.hex");
    test_step.dependOn(&hex_step.step);

    const explicit_format_hex_step = b.addInstallRawWithFormat(elf, "hello.foo", .hex);
    test_step.dependOn(&explicit_format_hex_step.step);

    const expected_hex = &[_][]const u8{
        ":020000021000EC",
        ":1000D400D001010001000000D20101000100000074",
        ":1000E40028020100010000002402010001000000B8",
        ":1000F4003A02010001000000E202010001000000D8",
        ":100104000C03010001000000A50202000000000031",
        ":1001140000000000000000000000000000000000DB",
        ":1001240000000000000000000000000000000000CB",
        ":1001340000000000000000000000000000000000BB",
        ":10014400AF02020098020100090000004D02010004",
        ":100154000900000001000000000000000000000091",
        ":1001640000080002008001010004000010000000EB",
        ":100174000000000000000000000000001F0000005C",
        ":1001840048010100000040888000FF01142800524B",
        ":100194000080610100040020110000000000000044",
        ":1001A40000000000000000001F000000000000002C",
        ":1001B400000000000000000000000000000000003B",
        ":1001C400000000000000000000000000000000002B",
        ":1001D400000000000000000000000000000000001B",
        ":1001E400000000000000000000000000000000000B",
        ":1001F4000000000000000000000000008702010071",
        ":1002040010000000200201002C0000006B0201001D",
        ":100214001B000000570201001300000072656D61AD",
        ":10022400696E646572206469766973696F6E2062B1",
        ":1002340079207A65726F206F72206E6567617469C8",
        ":1002440076652076616C756500636F727465782DD0",
        ":100254006D3400696E646578206F7574206F662054",
        ":10026400626F756E647300696E746567657220638E",
        ":10027400617374207472756E63617465642062695D",
        ":100284007473006469766973696F6E206279207A89",
        ":1002940065726F00636F727465785F6D340000007F",
        ":1002A40081B00091FFE700BEFDE7D0B502AF90B08A",
        ":1002B4000391029007A800F029F803990020069002",
        ":1002C40048680490FFE704990698019088420FD289",
        ":1002D400FFE7019903980068405C07F8310C17F8B0",
        ":1002E400311C07A800F021F8019801300690EAE7D4",
        ":1002F400029807A9B1E80C50A0E80C5091E81C50F2",
        ":1003040080E81C5010B0D0BDFFE7FEE7D0B502AFC7",
        ":1003140040F2DC11C0F20101B1E80C50A0E80C502D",
        ":1003240091E81C5080E81C50D0BD80B56F4688B061",
        ":1003340006906FF35F2127F80A1C37F80A0C049023",
        ":10034400012038B9FFE740F20020C0F2010000218B",
        ":10035400FFF7A6FF0498C0F3431027F8020C37F800",
        ":100364000A0C0390002038B9FFE7039800F01F003F",
        ":100374000290012038B914E040F20820C0F20100D4",
        ":100384000021FFF78DFF029800F01F0007F8030C0F",
        ":100394000698009037F8020C0146019109280ED303",
        ":1003A40006E040F21020C0F201000021FFF778FFC0",
        ":1003B40040F21820C0F201000021FFF771FF0099FC",
        ":1003C400019A51F8220017F803CC012303FA0CF325",
        ":1003D400184341F8220008B080BD81B000F03F000E",
        ":1003E4008DF802009DF802000F3000F03F00022853",
        ":1003F40004D3FFE700208DF8030003E001208DF80B",
        ":100404000300FFE79DF8030001B070470A000000F5",
        ":1004140012000000020071001200000066000000DB",
        ":1004240003007D0C06000000000000000001110123",
        ":10043400250E1305030E10171B0EB44219110112D9",
        ":0604440006000002340076",
        ":020000021000EC",
        ":1000D400D001010001000000D20101000100000074",
        ":1000E40028020100010000002402010001000000B8",
        ":1000F4003A02010001000000E202010001000000D8",
        ":100104000C03010001000000A50202000000000031",
        ":1001140000000000000000000000000000000000DB",
        ":1001240000000000000000000000000000000000CB",
        ":1001340000000000000000000000000000000000BB",
        ":10014400AF02020098020100090000004D02010004",
        ":100154000900000001000000000000000000000091",
        ":1001640000080002008001010004000010000000EB",
        ":100174000000000000000000000000001F0000005C",
        ":1001840048010100000040888000FF01142800524B",
        ":100194000080610100040020110000000000000044",
        ":1001A40000000000000000001F000000000000002C",
        ":1001B400000000000000000000000000000000003B",
        ":1001C400000000000000000000000000000000002B",
        ":1001D400000000000000000000000000000000001B",
        ":1001E400000000000000000000000000000000000B",
        ":1001F4000000000000000000000000008702010071",
        ":1002040010000000200201002C0000006B0201001D",
        ":100214001B000000570201001300000072656D61AD",
        ":10022400696E646572206469766973696F6E2062B1",
        ":1002340079207A65726F206F72206E6567617469C8",
        ":1002440076652076616C756500636F727465782DD0",
        ":100254006D3400696E646578206F7574206F662054",
        ":10026400626F756E647300696E746567657220638E",
        ":10027400617374207472756E63617465642062695D",
        ":100284007473006469766973696F6E206279207A89",
        ":1002940065726F00636F727465785F6D340000007F",
        ":1002A40081B00091FFE700BEFDE7D0B502AF90B08A",
        ":1002B4000391029007A800F029F803990020069002",
        ":1002C40048680490FFE704990698019088420FD289",
        ":1002D400FFE7019903980068405C07F8310C17F8B0",
        ":1002E400311C07A800F021F8019801300690EAE7D4",
        ":1002F400029807A9B1E80C50A0E80C5091E81C50F2",
        ":1003040080E81C5010B0D0BDFFE7FEE7D0B502AFC7",
        ":1003140040F2DC11C0F20101B1E80C50A0E80C502D",
        ":1003240091E81C5080E81C50D0BD80B56F4688B061",
        ":1003340006906FF35F2127F80A1C37F80A0C049023",
        ":10034400012038B9FFE740F20020C0F2010000218B",
        ":10035400FFF7A6FF0498C0F3431027F8020C37F800",
        ":100364000A0C0390002038B9FFE7039800F01F003F",
        ":100374000290012038B914E040F20820C0F20100D4",
        ":100384000021FFF78DFF029800F01F0007F8030C0F",
        ":100394000698009037F8020C0146019109280ED303",
        ":1003A40006E040F21020C0F201000021FFF778FFC0",
        ":1003B40040F21820C0F201000021FFF771FF0099FC",
        ":1003C400019A51F8220017F803CC012303FA0CF325",
        ":1003D400184341F8220008B080BD81B000F03F000E",
        ":1003E4008DF802009DF802000F3000F03F00022853",
        ":1003F40004D3FFE700208DF8030003E001208DF80B",
        ":100404000300FFE79DF8030001B070470A000000F5",
        ":1004140012000000020071001200000066000000DB",
        ":1004240003007D0C06000000000000000001110123",
        ":10043400250E1305030E10171B0EB44219110112D9",
        ":0604440006000002340076",
        ":020000022000DC",
        ":1002A40081B00091FFE700BEFDE7D0B502AF90B08A",
        ":1002B4000391029007A800F029F803990020069002",
        ":1002C40048680490FFE704990698019088420FD289",
        ":1002D400FFE7019903980068405C07F8310C17F8B0",
        ":1002E400311C07A800F021F8019801300690EAE7D4",
        ":1002F400029807A9B1E80C50A0E80C5091E81C50F2",
        ":1003040080E81C5010B0D0BDFFE7FEE7D0B502AFC7",
        ":1003140040F2DC11C0F20101B1E80C50A0E80C502D",
        ":1003240091E81C5080E81C50D0BD80B56F4688B061",
        ":1003340006906FF35F2127F80A1C37F80A0C049023",
        ":10034400012038B9FFE740F20020C0F2010000218B",
        ":10035400FFF7A6FF0498C0F3431027F8020C37F800",
        ":100364000A0C0390002038B9FFE7039800F01F003F",
        ":100374000290012038B914E040F20820C0F20100D4",
        ":100384000021FFF78DFF029800F01F0007F8030C0F",
        ":100394000698009037F8020C0146019109280ED303",
        ":1003A40006E040F21020C0F201000021FFF778FFC0",
        ":1003B40040F21820C0F201000021FFF771FF0099FC",
        ":1003C400019A51F8220017F803CC012303FA0CF325",
        ":1003D400184341F8220008B080BD81B000F03F000E",
        ":1003E4008DF802009DF802000F3000F03F00022853",
        ":1003F40004D3FFE700208DF8030003E001208DF80B",
        ":0C0404000300FFE79DF8030001B0704703",
        ":00000001FF",
    };

    test_step.dependOn(&CheckFileStep.create(b, hex_step.getOutputSource(), expected_hex).step);
    test_step.dependOn(&CheckFileStep.create(b, explicit_format_hex_step.getOutputSource(), expected_hex).step);
}