defmodule TinyCareTerminal do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  import Ratatouille.View

  alias TinyCareTerminal.Commands.ListCommitHistory

  alias TinyCareTerminal.App.Views.CommitHistory

  def init(context) do
    commit_history = ListCommitHistory.execute()

    %{window: context.window, commits: commit_history}
  end

  def update(model, msg) do
    case msg do
      _ -> model
    end
  end

  def render(model) do
    title = label(content: " Elixir Tiny Care Terminal")
    blank_line = label(content: "")

    {today, week} = CommitHistory.render(model.commits, model.window)

    view([title, blank_line, today, week])
  end
end
