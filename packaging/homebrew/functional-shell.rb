class FunctionalShell < Formula
  desc "Use map and filter in your shell"
  homepage "https://github.com/simeg/functional-shell"
  url "https://github.com/simeg/functional-shell/archive/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"
  head "https://github.com/simeg/functional-shell.git", branch: "master"

  def install
    bin.install "cmd/map", "cmd/filter"
    lib.install "lib" => "functional-shell"
    
    # Install shell completions if available
    if (buildpath/"scripts/completion").exist?
      bash_completion.install "scripts/completion/bash_completion" => "functional-shell"
      zsh_completion.install "scripts/completion/zsh_completion" => "_functional-shell"
    end
  end

  def caveats
    <<~EOS
      Functional programming utilities for shell scripting.
      
      Examples:
        echo 'hello world' | map to_upper
        find . -name '*.txt' | filter is_file
        seq 1 10 | filter even | map pow 2
      
      Available operations:
        map: add, sub, mul, pow, to_upper, to_lower, reverse, etc.
        filter: even, odd, is_file, is_dir, contains, starts_with, etc.
        
      Use 'map --help' or 'filter --help' for more information.
    EOS
  end

  test do
    # Test basic functionality
    assert_equal "HELLO", pipe_output("#{bin}/map to_upper", "hello")
    assert_equal "2", pipe_output("#{bin}/filter even", "1\n2\n3")
    
    # Test version flag
    assert_match "map 1.0.0", shell_output("#{bin}/map --version")
    assert_match "filter 1.0.0", shell_output("#{bin}/filter --version")
    
    # Test error handling
    assert_equal 1, shell_output("#{bin}/map", 1).exitstatus
    assert_equal 1, shell_output("#{bin}/filter", 1).exitstatus
  end
end