defmodule TinyCareTerminal do
  @moduledoc """
  The main application.
  """

  @behaviour Ratatouille.App

  import Ratatouille.View

  alias TinyCareTerminal.App.Views.CommitHistory

  def init(context) do
    %{window: context.window}
  end

  def update(model, msg) do
    case msg do
      _ -> model
    end
  end

  def render(model) do
    title = label(content: " Elixir Tiny Care Terminal")
    blank_line = label(content: "")

    {today, week} = CommitHistory.render(model, model.window)

    view([title, blank_line, today, week])
  end
end
