defmodule BowlingKataTest do
  use ExUnit.Case

  test "parses empty string to empty frame list" do
    assert [] = BowlingKata.parse_input("")
  end

  test "parses :nil to empty frame list" do
    assert [] = BowlingKata.parse_input(:nil)
  end

  test "parses strike as a list of 1 frame" do
    assert [_] = BowlingKata.parse_input("X")
  end

  test "parses two misses as a list of 1 frame" do
    assert [_] = BowlingKata.parse_input("--")
  end

  test "parses a spare as a list of 1 frame" do
    assert [_] = BowlingKata.parse_input("3/")
  end
  
  test "parses two rolls as a list of 1 frame" do
    assert [_] = BowlingKata.parse_input("35")
  end
end
