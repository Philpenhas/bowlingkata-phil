defmodule Frame do
  defstruct number: 1, type: :partial, rolls: []
end

defmodule BowlingGame do
  defstruct current_frame: %Frame{}, frames: []
end

defmodule BowlingKata do

  def parse_input(""), do: []
  def parse_input(:nil), do: []
  def parse_input(rolls) do
    game = parse_frames(String.graphemes(rolls))
    game.frames
  end

  def parse_frames(rolls) do
    parse_frame %BowlingGame{}, rolls
  end

  defp parse_frame(game, []) do
    game
  end

  defp parse_frame(%BowlingGame{frames: frames}, ["X" | rest]) do
    game = %BowlingGame{frames: [%Frame{type: :strike, rolls: [10]} | frames]}
    parse_frame game, rest
  end

  defp parse_frame(%BowlingGame{frames: frames}, ["-", "-" | rest]) do
    game = %BowlingGame{frames: [%Frame{type: :strike, rolls: [10]} | frames]}
    parse_frame game, rest
  end

  defp parse_frame(%BowlingGame{frames: frames}, [r1, "/" | rest]) do
    game = %BowlingGame{frames: [%Frame{type: :spare, rolls: [r1]} | frames]}
    parse_frame game, rest
  end

  defp parse_frame(%BowlingGame{frames: frames}, [r1, r2 | rest]) do
    game = %BowlingGame{frames: [%Frame{type: :spare, rolls: [r1, r2]} | frames]}
    parse_frame game, rest
  end
end
