defmodule TinyCareTerminal.App.Views.CommitHistory do
  @moduledoc """
  Builds a view for displaying Git commits history.
  """

  import Ratatouille.View

  alias Ratatouille.Renderer.Element
  alias TinyCareTerminal.Models.Commit
  alias TinyCareTerminal.Models.CommitHistory

  @spec render(CommitHistory.t(), map()) :: {Element.t(), Element.t()}
  def render(%CommitHistory{} = history, window) do
    %{today: today_commits, last_week: last_week_commits, repo_path: path} = history

    today_opts = [
      column_size: 6,
      height: round(window.height * 0.3),
      title: " 📆  Today ",
      path: path
    ]

    last_week_opts = [
      column_size: 6,
      height: :fill,
      title: " 🗓  Last Week ",
      path: path
    ]

    today = render_commits(today_commits, today_opts)

    week = render_commits(last_week_commits, last_week_opts)

    {today, week}
  end

  defp render_commits([], opts) do
    height = opts[:height]
    title = opts[:title]
    column_size = opts[:column_size]
    path = opts[:path]

    content = """
    No commits found for path '#{path}'. Are you sure it's a Git repo?

    Tip: Make sure to provide the full path to the repo and if ou are using shorthands like
    '~/SomeFolder/SomeRepo', don't use strings when exporting the environment variable.
    """

    row do
      column(size: column_size) do
        panel(title: title, height: height) do
          label(
            content: content,
            color: :green
          )
        end
      end
    end
  end

  defp render_commits(commits, opts) do
    height = opts[:height]
    title = opts[:title]
    column_size = opts[:column_size]
    path = opts[:path]

    row do
      column(size: column_size) do
        panel(title: title, height: height) do
          label(content: "Project path: #{path}", color: :green)
          label(content: "")

          row do
            column(size: column_size) do
              for %Commit{} = commit <- commits do
                label do
                  text(content: commit.hash, color: :red)
                  text(content: " - ")
                  text(content: commit.message)
                  text(content: " ")
                  text(content: commit.relative_date, color: :green)
                end
              end
            end
          end
        end
      end
    end
  end
end
