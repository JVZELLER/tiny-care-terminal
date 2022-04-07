defmodule TinyCareTerminal do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]

  alias TinyCareTerminal.Models.State

  alias TinyCareTerminal.Views.CommitHistory

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)

  def init(context), do: State.init(context.window)

  def update(state, msg) do
    case msg do
      {:event, %{key: key}} when key in [@arrow_up, @arrow_down] ->
        new_cursor =
          case key do
            @arrow_up -> max(state.cursor_position - 1, 0)
            @arrow_down -> state.cursor_position + 1
          end

        %{state | cursor_position: new_cursor}

      _ ->
        state
    end
  end

  def render(state) do
    title = label(content: " Elixir Tiny Care Terminal\n")

    {today, week} = CommitHistory.render(state)

    view([title, today, week])
  end
end
