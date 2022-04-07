defmodule TinyCareTerminal.Views.CommitHistory do
  @moduledoc """
  Builds a view for displaying Git commits history.
  """

  import Ratatouille.View

  alias Ratatouille.Renderer.Element

  alias TinyCareTerminal.Models.Commit
  alias TinyCareTerminal.Models.CommitHistory
  alias TinyCareTerminal.Models.State

  alias TinyCareTerminal.Views.Components.Pagination

  @default_today_opts [column_size: 6, title: " 📆  Today ", page_size: 5]
  @default_week_opts [column_size: 6, title: " 📆  Week ", page_size: 20, height: :fill]

  @spec render(State.t()) :: {Element.t(), Element.t()}
  def render(%{commit_history: %{git_repo?: false, repo_path: path}, window: window}) do
    today =
      render_no_git_repo(@default_today_opts ++ [height: round(window.height * 0.3), path: path])

    week = render_no_git_repo(@default_week_opts ++ [path: path])

    {today, week}
  end

  def render(model) do
    %{
      commit_history: %CommitHistory{} = commit_history,
      cursor_position: cursor_position,
      window: window
    } = model

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
    page_size = opts[:page_size]

    cursor_position = min(cursor_position, length(commits) - 1)
    page_number = Pagination.page(cursor_position, page_size) + 1
    total_pages = Pagination.total_pages(commits, page_size)

    commits_to_display = Pagination.page_slice(commits, cursor_position, page_size)

    row do
      column(size: column_size) do
        panel(title: title, height: height) do
          label(content: "Project path: #{path}\n", color: :green)

          label(
            content: "#{page_size} commits of page #{page_number} / #{total_pages}\n",
            color: :green
          )

          row do
            column(size: column_size) do
              for %Commit{} = commit <- commits_to_display do
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
