defmodule TinyCareTerminal.Models.State do
  @moduledoc """
  Represents de state of the application.
  """

  alias TinyCareTerminal.Models.CommitHistory

  alias TinyCareTerminal.Commands.ListCommitHistory

  defstruct [:window, :commit_history, :cursor]

  @type t :: %__MODULE__{
          window: map(),
          commit_history: CommitHistory.t(),
          cursor: non_neg_integer()
        }

  @spec create(map()) :: __MODULE__.t()
  def create(params), do: struct(__MODULE__, params)

  @spec init(map()) :: __MODULE__.t()
  def init(window) do
    commit_history = ListCommitHistory.execute()

    %{window: window, commit_history: commit_history, cursor_position: 0}
  end
end
