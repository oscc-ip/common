`ifndef INC_HELPER_SV
`define INC_HELPER_SV

class Helper;
  stirng name;

  function new(string name = "sv_helper");
    this.name = name;
  endfunction

  static function void start_banner();
    $display("  ______    ______    ______    ______         ______  _______  ");
    $display(" /      \\  /      \\  /      \\  /      \\       |      \\|       \\ ");
    $display("|  $$$$$$\\|  $$$$$$\\|  $$$$$$\\|  $$$$$$\\       \\$$$$$$| $$$$$$$\\");
    $display("| $$  | $$| $$___\\$$| $$   \\$$| $$   \\$$        | $$  | $$__/ $$");
    $display("| $$  | $$ \\$$    \\ | $$      | $$              | $$  | $$    $$");
    $display("| $$  | $$ _\\$$$$$$\\| $$   __ | $$   __         | $$  | $$$$$$$ ");
    $display("| $$__/ $$|  \\__| $$| $$__/  \\| $$__/  \\       _| $$_ | $$      ");
    $display(" \\$$    $$ \\$$    $$ \\$$    $$ \\$$    $$      |   $$ \\| $$      ");
    $display("  \\$$$$$$   \\$$$$$$   \\$$$$$$   \\$$$$$$        \\$$$$$$ \\$$      ");
    $display("");
    $display("");
  endfunction

  static function void end_banner();
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
  endfunction

endclass

`endif
