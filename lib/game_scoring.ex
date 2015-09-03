defmodule GameScoring do
  def score(frames) when is_list(frames) do
    if Enum.count(frames) < 10 do
      {:error, :full_game_required}
    else
      [current | rest] = frames
      {:ok, score_do(0, current, rest)}
    end
  end

  defp score_do(score, current, []) do
    {:ok, current_score} = score_frame(current, [])
    score + current_score
  end

  defp score_do(score, current, rest = [next | beyond]) do
    {:ok, current_score} = score_frame(current, rest)
    score_do(score + current_score, next, beyond)
  end

  def score_frame(frame = %Frame{type: type}, rest)
  when type == :strike or type == :spare do
    rolls = get_next_rolls([frame | rest], 3)

    if Enum.count(rolls) == 3 do
      {:ok, Enum.sum(rolls)}
    else
      {:error, :partial_game}
    end
  end

  def score_frame(frame = %Frame{type: :scored}, _rest_of_game) do
    {:ok, Enum.sum(frame.rolls)}
  end

  def score_frame(_frame, _rest_of_game) do
    {:error, :partial_game}
  end

  defp get_next_rolls(frames, count) do
      frames
        |> Enum.flat_map(fn(f) -> f.rolls end)
        |> Enum.take(count)
  end
end
