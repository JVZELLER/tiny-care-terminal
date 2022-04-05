defmodule TinyCareTerminal.Models.Commit do
  @moduledoc """
  Represents a Git commit.
  """

  defstruct [:hash, :message, :relative_date]

  @type t :: %__MODULE__{hash: String.t(), message: String.t(), relative_date: String.t()}

  @spec create(map()) :: Commit.t()
  def create(params), do: struct(__MODULE__, params)
end
