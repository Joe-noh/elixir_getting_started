ExUnit.start

defmodule BinariesStringsCharLists do
  use ExUnit.Case

  test "UTF-8 and Unicode" do
    english  = "English"
    japanese = "日本語"

    assert String.length(english)  == 7
    assert String.length(japanese) == 3
    assert byte_size(english)  == 7
    assert byte_size(japanese) == 9
    assert ?e == 101
    assert ?日 == 26085
    assert String.codepoints(english)  == ["E", "n", "g", "l", "i", "s", "h"]
    assert String.codepoints(japanese) == ["日", "本", "語"]
  end

  test "Binaries" do
    english  = "English"
    japanese = "日本語"

    assert is_binary(<<1, 2, 3, 4>>) == true
    assert byte_size(<<1, 2, 3, 4>>) == 4
    assert String.valid?(<<239, 191, 191>>) == false
    assert String.valid?(japanese) == true
    assert (<<1, 2>> <> <<3, 4>>) == <<1, 2, 3, 4>>
    assert (japanese <> <<0>>) == <<230, 151, 165, 230, 156, 172, 232, 170, 158, 0>>
    assert <<256>> == <<0>>
    assert <<256 :: size(16)>> == <<1, 0>>
    assert <<256 :: utf8>> == "Ā"
    assert ("Ā" <> <<0>>) == <<196, 128, 0>>
    assert <<2 :: size(1)>> == <<0 :: size(1)>>
    assert bit_size(<<0 :: size(1)>>) == 1
    assert is_binary(<<1 :: size(8)>>) == true
    assert is_binary(<<1 :: size(1)>>) == false
    assert is_bitstring(<<1 :: size(8)>>) == true
    assert is_bitstring(<<1 :: size(1)>>) == true

    <<1, 2, x>> = <<1, 2, 3>>
    assert x == 3
    assert_raise MatchError, fn ->
      <<1, 2, _x>> = <<1, 2, 3, 4>>
    end

    <<1, 2, x :: binary>> = <<1, 2, 3, 4>>
    assert x == <<3, 4>>

    "En" <> rest = english
    assert rest == "glish"
  end

  test "Char Lists" do
    string = "日本語"
    list   = '日本語'

    assert list == [26085, 26412, 35486]
    assert is_list(list)   == true
    assert is_list(string) == false
    assert to_string(list)      == string
    assert to_char_list(string) == list
  end
end
