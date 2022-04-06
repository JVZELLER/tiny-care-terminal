defmodule TinyCareTerminal do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]

  alias TinyCareTerminal.Commands.ListCommitHistory

  alias TinyCareTerminal.App.Views.CommitHistory

  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)

  def init(context) do
    commit_history = ListCommitHistory.execute()

    %{window: context.window, commit_history: commit_history, cursor_position: 0}
  end

  def update(model, msg) do
    case msg do
      {:event, %{key: key}} when key in [@arrow_up, @arrow_down] ->
        new_cursor =
          case key do
            @arrow_up -> max(model.cursor_position - 1, 0)
            @arrow_down -> model.cursor_position + 1
          end

        %{model | cursor_position: new_cursor}

      _ ->
        model
    end
  end

  def render(model) do
    title = label(content: " Elixir Tiny Care Terminal\n")

    {today, week} = CommitHistory.render(model, model.window)

    view([title, today, week])
  end
end
