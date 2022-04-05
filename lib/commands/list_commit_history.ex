defmodule TinyCareTerminal.Commands.ListCommitHistory do
  @moduledoc """
  Fetches the Git history from a project.
  """

  alias TinyCareTerminal.App.Models.Commit
  alias TinyCareTerminal.App.Models.CommitHistory

  @format "%h`%s`(%cd)"

  @spec execute() :: [Commit.t()]
  def execute do
    (git_repo?() and list_commits()) || []
  end

  defp git_repo? do
    repo_path = path()

    "git"
    |> System.cmd(["rev-parse", "HEAD"], cd: repo_path, stderr_to_stdout: true)
    |> case do
      {_result, 0} -> true
      _error -> false
    end
  end

  defp list_commits do
    repo_path = path()

    today_commits = list_today_commits(repo_path)
    last_week_commits = list_last_week_commits(repo_path)

    CommitHistory.create(%{today: today_commits, last_week: last_week_commits})
  end

  def list_today_commits(path) do
    today = Date.to_iso8601(Date.utc_today())
    list_commits(path, ["--since=#{today}"])
  end

  defp list_last_week_commits(path) do
    last_week = Date.utc_today() |> Date.add(-7) |> Date.to_iso8601()
    list_commits(path, ["--since=#{last_week}"])
  end

  defp list_commits(path, since_opt) do
    git_opts = ["log", "--pretty=format:#{@format}", "--relative-date"] ++ since_opt

    "git"
    |> System.cmd(git_opts, cd: path, stderr_to_stdout: true)
    |> parse_commits()
  end

  defp parse_commits({"", 0}), do: []
  defp parse_commits({_, exit_code}) when exit_code != 0, do: []

  defp parse_commits({commits, 0}) do
    commits
    |> String.split("\n")
    |> Enum.map(fn commit ->
      [hash, message, date] = String.split(commit, "`")
      Commit.create(%{hash: hash, message: message, relative_date: date})
    end)
  end

  defp path, do: Keyword.get(config(), :path)

  defp depth, do: Keyword.get(config(), :depth)

  defp config, do: Application.get_env(:tiny_care_terminal, __MODULE__)
end
