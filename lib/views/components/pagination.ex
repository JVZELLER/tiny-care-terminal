defmodule TinyCareTerminal.Views.Components.Pagination do
  @doc """
  Utility functions for paginated resources.
  """

  @page_size 10

  @spec total_pages(list(term()), non_neg_integer()) :: non_neg_integer()
  def total_pages(resources, total_page \\ @page_size)

  def total_pages([_ | _] = resources, page_size) do
    resources
    |> length()
    |> Kernel./(page_size)
    |> :math.ceil()
    |> round()
  end

  def total_pages(_, _), do: 0

  @spec page(non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  def page(cursor, page_size \\ @page_size), do: div(cursor, page_size)

  @spec page_slice(list(term()), non_neg_integer()) :: list(term())
  def page_slice(resources, cursor, page_size \\ @page_size),
    do: Enum.slice(resources, page(cursor, page_size) * page_size, page_size)
end
