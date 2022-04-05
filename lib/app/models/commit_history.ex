defmodule TinyCareTerminal.App.Models.CommitHistory do
  @moduledoc """
  Represents the history of Git commits.
  """
  alias TinyCareTerminal.App.Models.Commit

  defstruct today: [], last_week: []

  @type t :: %__MODULE__{today: [Commit.t()], last_week: [Commit.t()]}

  @spec create(map()) :: CommitHistory.t()
  def create(params), do: struct(__MODULE__, params)
end
