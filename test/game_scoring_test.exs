defmodule GameScoringTest do
  use ExUnit.Case

  test "it only scores a list of frames" do
    assert_raise FunctionClauseError, fn ->
      GameScoring.score(%Frame{})
    end
  end

  test "it returns an error tuple if given a partial game" do
    assert {:error, :full_game_required} = GameScoring.score([])
  end

  test "it scores a :scored frame as the sum of rolls" do
    frame = %Frame{type: :scored, rolls: [0, 5]}
    assert {:ok, 5} = GameScoring.score_frame(frame, [])
  end

  test "it scores a :spare frame as 10 plus the next roll" do
    frame = %Frame{type: :spare, rolls: [0, 10]}
    rest = [%Frame{type: :scored, rolls: [3,5]}]

    assert {:ok, 13} = GameScoring.score_frame(frame, rest)
  end

  test "it returns an error tuple if scoring a spare without any additional frames" do
    frame = %Frame{type: :spare, rolls: [0, 10]}

    assert {:error, :partial_game} = GameScoring.score_frame(frame, [])
  end

  test "it scores a :strike frame as 10 plus the next two rolls" do
    frame = %Frame{type: :strike, rolls: [10]}
    rest = [%Frame{type: :scored, rolls: [3,5]}]

    assert {:ok, 18} = GameScoring.score_frame(frame, rest)
  end

  test "it scores three :strike frames in a row as a 30" do
    frame = %Frame{type: :strike, rolls: [10]}
    rest = [
      %Frame{type: :strike, rolls: [10]},
      %Frame{type: :strike, rolls: [10]}
    ]

    assert {:ok, 30} = GameScoring.score_frame(frame, rest)
  end

  test "it scores a tenth frame of :strike as sum of it's rolls" do
    frame = %Frame{type: :strike, rolls: [10, 3, 7]}
    rest = []

    assert {:ok, 20} = GameScoring.score_frame(frame, rest)
  end

  test "it scores a tenth frame of :spare as sum of it's rolls" do
    frame = %Frame{type: :strike, rolls: [7, 3, 7]}
    rest = []

    assert {:ok, 17} = GameScoring.score_frame(frame, rest)
  end

  test "it scores a perfect game" do
    frames = BowlingKata.parse_input("XXXXXXXXXXXX")
    
    assert {:ok, 300} = GameScoring.score(frames)
  end
end
