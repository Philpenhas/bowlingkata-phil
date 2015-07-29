defmodule BowlingKataTest do
  use ExUnit.Case

  test "parses empty string to empty frame list" do
    assert [] = BowlingKata.parse_input("")
  end

  test "parses :nil to empty frame list" do
    assert [] = BowlingKata.parse_input(:nil)
  end

  test "invalid game string rasies MatchError" do
    assert_raise FunctionClauseError, fn ->
      BowlingKata.parse_input("XX/")
    end
  end

  test "parses a miss and roll of 5 as 0 and 5" do
    assert [frame] = BowlingKata.parse_input("-5")
    assert %Frame{type: :scored, rolls: [0, 5]} = frame
  end

  test "parses a roll of 5 and a miss as 5 and 0" do
    assert [frame] = BowlingKata.parse_input("5-")
    assert %Frame{type: :scored, rolls: [5, 0]} = frame
  end

  test "parses a roll of two misses as 0 and 0" do
    assert [frame] = BowlingKata.parse_input("--")
    assert %Frame{type: :scored, rolls: [0, 0]} = frame
  end

  test "parses 2 rolls as a list of 1 frame" do
    assert [frame] = BowlingKata.parse_input("35")
    assert %Frame{type: :scored, rolls: [3, 5]} = frame
  end

  test "parses a strike as a list of 1 frames" do
    assert [frame] = BowlingKata.parse_input("X")
    assert %Frame{type: :strike, rolls: [10]} = frame
  end

  test "parses a strike as a list of 1 frames lower case x" do
    assert [frame] = BowlingKata.parse_input("x")
    assert %Frame{type: :strike, rolls: [10]} = frame
  end

  test "parses a spare as a list of 1 frame" do
    assert [frame] = BowlingKata.parse_input("3/")
    assert %Frame{type: :spare, rolls: [3, 7]} = frame
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

  test "parses 2 strikes as a list of 2 frames" do
    assert [frame1, frame2] = BowlingKata.parse_input("XX")
    assert %Frame{type: :strike, rolls: [10]} = frame1
    assert %Frame{type: :strike, rolls: [10]} = frame2
  end

  test "perfect game parses into 10 frames of strikes" do
    frames = BowlingKata.parse_input("XXXXXXXXXXXX")

    assert 10 = Enum.count(frames)
    assert Enum.all(frames, &(&1.type == :strike))
  end

  test "a normal game with spare on 10th frame with strike as last roll parses into 10 frames" do
    frames = BowlingKata.parse_input("3453131734532233233/X")

    assert 10 = Enum.count(frames)
    assert Enum.all(frames, &(&1.type == :strike))
  end

  test "a normal game with spare and simple score on 10th frame game parses into 10 frames" do
    frames = BowlingKata.parse_input("3453131734532233233/5")

    assert 10 = Enum.count(frames)
    assert Enum.all(frames, &(&1.type == :strike))
  end
end
