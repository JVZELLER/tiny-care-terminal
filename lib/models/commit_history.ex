defmodule TinyCareTerminal.Models.CommitHistory do
  @moduledoc """
  Represents the history of Git commits.
  """
  alias TinyCareTerminal.Models.Commit

  defstruct today: [], last_week: [], repo_path: ""

  @type t :: %__MODULE__{today: [Commit.t()], last_week: [Commit.t()], repo_path: String.t()}

  @spec create(map()) :: CommitHistory.t()
  def create(params), do: struct(__MODULE__, params)
end
