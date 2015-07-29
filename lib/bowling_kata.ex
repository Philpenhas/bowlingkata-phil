defmodule Frame do
  defstruct type: :partial, rolls: []
end

defmodule BowlingGame do
  defstruct frames: []
end

defmodule BowlingKata do

  def parse_input(""), do: []
  def parse_input(:nil), do: []
  def parse_input(rolls) do
    rolls
      |> String.upcase
      |> String.graphemes
      |> parse_frames
      |> (&(&1.frames)).()
      |> Enum.reverse
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
    game = %BowlingGame{frames: [%Frame{type: :scored, rolls: [0,0]} | frames]}
    parse_frame game, rest
  end

  defp parse_frame(%BowlingGame{frames: frames}, [r1, "-" | rest]) do
    {rvalue, _} = Integer.parse(r1)
    game = %BowlingGame{frames: [%Frame{type: :scored, rolls: [rvalue, 0]} | frames]}
    parse_frame game, rest
  end

  defp parse_frame(%BowlingGame{frames: frames}, ["-", r2 | rest]) do
    {rvalue, _} = Integer.parse(r2)
    game = %BowlingGame{frames: [%Frame{type: :scored, rolls: [0,rvalue]} | frames]}
    parse_frame game, rest
  end

  defp parse_frame(%BowlingGame{frames: frames}, [r1, "/" | rest]) do
    {rvalue, _} = Integer.parse(r1)
    frame = %Frame{type: :spare, rolls: [rvalue, 10 - rvalue]}
    game = %BowlingGame{frames: [frame | frames]}
    parse_frame game, rest
  end

  defp parse_frame(%BowlingGame{frames: frames}, [r1, r2 | rest]) do
    {r1value, _} = Integer.parse(r1)
    {r2value, _} = Integer.parse(r2)
    game = %BowlingGame{
      frames: [%Frame{type: :scored, rolls: [r1value, r2value]} | frames]
    }
    parse_frame game, rest
  end
end
