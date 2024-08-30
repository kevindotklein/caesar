Code.require_file("lib/lexer/lexer.ex")

defmodule Caesar do
  def read(src) do
    Caesar.Lexer.init(src)
  end
end

IO.inspect(Caesar.read("let a = 1 <= 2"))
