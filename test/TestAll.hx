import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function addTests(runner : Runner) {
    runner.addCase(new thx.format.TestBigIntFormat());
    runner.addCase(new thx.format.TestDateFormat());
    runner.addCase(new thx.format.TestDecimalFormat());
    runner.addCase(new thx.format.TestFormat());
    runner.addCase(new thx.format.TestNumberFormat());
    runner.addCase(new thx.format.TestTimeFormat());
  }

  public static function main() {
    var runner = new Runner();
    addTests(runner);
    Report.create(runner);
    runner.run();
  }
}
