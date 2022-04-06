defmodule TinyCareTerminal.App.Views.CommitHistory do
  @moduledoc """
  Builds a view for displaying Git commits history.
  """

  import Ratatouille.View

  alias Ratatouille.Renderer.Element
  alias TinyCareTerminal.Models.Commit
  alias TinyCareTerminal.Models.CommitHistory

  @default_today_opts [column_size: 6, title: " 📆  Today "]
  @default_week_opts [column_size: 6, title: " 📆  Today ", height: :fill]

  @spec render(map(), map()) :: {Element.t(), Element.t()}
  def render(%{commit_history: %{git_repo?: false, repo_path: path}}, window) do
    today =
      render_no_git_repo(@default_today_opts ++ [height: round(window.height * 0.3), path: path])

    week = render_no_git_repo(@default_week_opts ++ [path: path])

    {today, week}
  end

  def render(model, window) do
    %{commit_history: %CommitHistory{} = commit_history, cursor_position: cursor_position} = model

    today_opts =
      [
        height: round(window.height * 0.3),
        path: commit_history.repo_path,
        cursor_position: cursor_position
      ] ++ @default_today_opts

    last_week_opts =
      [
        path: commit_history.repo_path,
        cursor_position: cursor_position
      ] ++ @default_week_opts

    today = render_commits(commit_history.today, today_opts)

    week = render_commits(commit_history.last_week, last_week_opts)

    {today, week}
  end

  defp render_no_git_repo(opts) do
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
    cursor_position = opts[:cursor_position]

    cursor_position = min(cursor_position, length(commits) - 1)

    row do
      column(size: column_size) do
        panel(title: title, height: height) do
          label(content: "Project path: #{path}\n", color: :green)

          viewport(offset_y: cursor_position) do
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
end
