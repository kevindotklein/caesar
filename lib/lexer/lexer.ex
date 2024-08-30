defmodule Caesar.Lexer do
  @dialyzer {:nowarn_function, {:read_number, 2}}
  @dialyzer {:nowarn_function, {:read_identifier, 2}}

  @eof       :eof
  @number    :number
  @ident     :ident
  @lparen    :lparen
  @rparen    :rparen
  @equal     :equal
  @not_equal :not_equal
  @plus      :plus
  @minus     :minus
  @asterisk  :asterisk
  @slash     :slash
  @lt        :less_than
  @lte       :less_than_equal
  @gt        :greater_than
  @gte       :greater_than_equal
  @assign    :assign

  @let       :let

  defguardp is_whitespace(c) when c in ~c[ \n\t]
  defguardp is_letter(c) when c in ?a..?z or c in ?A..?Z or c == ?_
  defguardp is_digit(c) when c in ?0..?9

  def init(src) when is_binary(src) do
    lex(src, [])
  end

  defp lex(<<>>, tokens), do: [@eof | tokens] |> Enum.reverse()

  defp lex(<<c::8, rest::binary>>, tokens) when is_whitespace(c), do: lex(rest, tokens)

  defp lex(src, tokens) do
    {token, rest} = tokenize(src)
    lex(rest, [token | tokens])
  end

  defp tokenize(<<">=", rest::binary>>), do: {@gte,        rest}
  defp tokenize(<<"<=", rest::binary>>), do: {@lte,        rest}
  defp tokenize(<<"==", rest::binary>>), do: {@equal,      rest}
  defp tokenize(<<"!=", rest::binary>>), do: {@not_equal,  rest}
  defp tokenize(<<"(", rest::binary>>), do:  {@lparen,     rest}
  defp tokenize(<<")", rest::binary>>), do:  {@rparen,     rest}
  defp tokenize(<<"=", rest::binary>>), do:  {@assign,     rest}
  defp tokenize(<<"+", rest::binary>>), do:  {@plus,       rest}
  defp tokenize(<<"-", rest::binary>>), do:  {@minus,      rest}
  defp tokenize(<<"*", rest::binary>>), do:  {@asterisk,   rest}
  defp tokenize(<<"/", rest::binary>>), do:  {@slash,      rest}
  defp tokenize(<<">", rest::binary>>), do:  {@gt,         rest}
  defp tokenize(<<"<", rest::binary>>), do:  {@lt,         rest}
  defp tokenize(<<c::8, rest::binary>>) when is_digit(c), do: read_number(rest, <<c>>)
  defp tokenize(<<c::8, rest::binary>>) when is_letter(c), do: read_identifier(rest, <<c>>)

  defp read_number(<<c::8, rest::binary>>, acc) when is_digit(c) do
    read_number(rest, [acc | <<c>>])
  end

  defp read_number(rest, acc) do
    {{@number, IO.iodata_to_binary(acc)}, rest}
  end

  defp read_identifier(<<c::8, rest::binary>>, acc) when is_letter(c) do
    read_identifier(rest, [acc | <<c>>])
  end

  defp read_identifier(rest, acc) do
    {IO.iodata_to_binary(acc) |> tokenize_word(), rest}
  end

  defp tokenize_word("let"), do: @let
  defp tokenize_word(word), do: {@ident, word}

end
