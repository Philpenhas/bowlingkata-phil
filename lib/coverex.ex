defmodule CoverEx do
  def start(compile_path, args) do
    Mix.shell.info "Cover compiling modules ... "
    _ = :cover.start

    case :cover.compile_beam_directory(compile_path |> to_char_list) do
      results when is_list(results) ->
        :ok
      {:error, _} ->
        Mix.raise "Failed to cover compile directory: " <> compile_path
    end

    fn() -> 
      Mix.shell.info "\nGenerating cover results ... "

      Enum.each :cover.modules, fn(mod) ->
        {:ok, lines} = :cover.analyse(mod, :coverage, :clause)
        Enum.each lines, fn(line) -> Mix.shell.info inspect(line) end
      end
    end
  end
end
