`ifndef INC_HELPER_SV
`define INC_HELPER_SV

class Helper;
  typedef enum {
    NORM  = 0,
    DEBUG,
    INFO,
    WARN,
    ERR
  } log_lev_t;

  typedef enum {
    EQUAL,
    GRET,
    LESS,
    GREQ,
    LEEQ
  } cmp_t;

  static string    name       = "sv_helper";
  static log_lev_t log_lev    = INFO;
  static int       all_num    = 0;
  static int       failed_num = 0;

  static function void start_banner();
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
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
    test_summary();
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
  endfunction

  static function void test_summary();
    $display("%t === [ALL TEST]: %0d [FAILED TEST]: %0d [PASS TEST]: %0d === ", $time, all_num,
             failed_num, all_num - failed_num);
  endfunction

  static task print(input string info);
    if (log_lev > NORM) begin
      $display("%t [%s] %s", $time, log_lev, info);
    end
  endtask

  static task check(input string name, input bit [31:0] actual, expected);
    if (log_lev > NORM) begin
      $display("%t [%s] checking %s actual: %h, expected: %h", $time, log_lev, name, actual,
               expected);
    end

    all_num++;
    if (actual !== expected) begin
      failed_num++;
    end
  endtask
endclass

`endif
