defmodule Frame do
  defstruct type: :scored, rolls: []
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
      |> parse_frame(%BowlingGame{})
      |> (&(&1.frames)).()
      |> Enum.reverse
  end

  defp parse_frame([], game) do
    game
  end

  defp parse_frame(["X" | rest], %BowlingGame{frames: frames}) do
    game = %BowlingGame{frames: [%Frame{type: :strike, rolls: [10]} | frames]}
    parse_frame rest, game
  end

  defp parse_frame(["-", "-" | rest], %BowlingGame{frames: frames}) do
    game = %BowlingGame{frames: [%Frame{type: :scored, rolls: [0,0]} | frames]}
    parse_frame rest, game
  end

  defp parse_frame([r1, "-" | rest], %BowlingGame{frames: frames}) do
    {rvalue, _} = Integer.parse(r1)
    game = %BowlingGame{frames: [%Frame{type: :scored, rolls: [rvalue, 0]} | frames]}
    parse_frame rest, game
  end

  defp parse_frame(["-", r2 | rest], %BowlingGame{frames: frames}) do
    {rvalue, _} = Integer.parse(r2)
    game = %BowlingGame{frames: [%Frame{type: :scored, rolls: [0,rvalue]} | frames]}
    parse_frame rest, game
  end

  defp parse_frame([r1, "/" | rest], %BowlingGame{frames: frames}) do
    {rvalue, _} = Integer.parse(r1)
    frame = %Frame{type: :spare, rolls: [rvalue, 10 - rvalue]}
    game = %BowlingGame{frames: [frame | frames]}
    parse_frame rest, game
  end

  defp parse_frame([r1, r2 | rest], %BowlingGame{frames: frames}) do
    {r1value, _} = Integer.parse(r1)
    {r2value, _} = Integer.parse(r2)
    game = %BowlingGame{
      frames: [%Frame{type: :scored, rolls: [r1value, r2value]} | frames]
    }
    parse_frame rest, game
  end
end
