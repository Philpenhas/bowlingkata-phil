defmodule BowlingKataTest do
  use ExUnit.Case

  test "parses empty string to empty frame list" do
    assert [] = BowlingKata.parse_input("")
  end

  test "parses :nil to empty frame list" do
    assert [] = BowlingKata.parse_input(:nil)
  end

  test "parses strike as a list of 1 strike frame" do
    assert [%Frame{type: :strike}] = BowlingKata.parse_input("X")
  end

  test "parses 2 misses as a list of 1 empty frame" do
    assert [%Frame{type: :scored}] = BowlingKata.parse_input("--")
  end

  test "parses miss and a roll as a list of 1 plain frame" do
    assert [%Frame{type: :scored}] = BowlingKata.parse_input("-4")
  end

  test "parses a spare as a list of 1 spare frame" do
    assert [%Frame{type: :spare}] = BowlingKata.parse_input("3/")
  end

  test "parses a strike and scored frames as a list of 2 frames respectively" do
    assert [strike, scored] = BowlingKata.parse_input("X4-")
    assert [%Frame{type: :strike}, %Frame{type: :scored}] = [strike, scored]
  end

  test "parses a zero score and scored frames as a list of 2 frames respectively" do
    assert [zero, scored] = BowlingKata.parse_input("--44")
    assert [%Frame{type: :scored}, %Frame{type: :scored}] = [zero, scored]
  end

  test "parses a strike and spare frames as a list of 2 frames respectively" do
    assert [strike, spare] = BowlingKata.parse_input("X4/")
    assert [%Frame{type: :strike}, %Frame{type: :spare}] = [strike, spare] 
  end

  test "parses a scored and spare frames as a list of 2 frames respectively" do
    assert [scored, spare] = BowlingKata.parse_input("424/")
    assert [%Frame{type: :scored}, %Frame{type: :spare}] = [scored, spare] 
  end

  test "parses a scored and scored frames as a list of 2 frames respectively" do
    assert [scored1, scored2] = BowlingKata.parse_input("4245")
    assert [%Frame{type: :scored}, %Frame{type: :scored}] = [scored1, scored2]
  end

  test "parses a miss and roll of 5 as 0 and 5" do
    assert [frame] = BowlingKata.parse_input("-5")
    assert %Frame{type: :scored, rolls: [0, 5]} = frame
  end

  test "parses a roll of 5 and a miss as 5 and 0" do
    assert [frame] = BowlingKata.parse_input("5-")
    assert %Frame{type: :scored, rolls: [5, 0]} = frame
  end

  test "parses 2 rolls as a list of 1 frame" do
    assert [_] = BowlingKata.parse_input("35")
  end

  test "parses 2 strikes as a list of 2 frames" do
    assert [_, _] = BowlingKata.parse_input("XX")
  end
end
