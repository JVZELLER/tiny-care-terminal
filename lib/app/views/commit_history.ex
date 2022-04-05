defmodule TinyCareTerminal.App.Views.CommitHistory do
  @moduledoc """
  Builds a view for displaying Git commits history.
  """

  import Ratatouille.View

  def render(_model, window) do
    today =
      row do
        column(size: 6) do
          panel(title: " 📆  Today ", height: round(window.height * 0.3)) do
            label(content: "Project path: ~/Projects/Stone", color: :green)
            label(content: "")

            row do
              column(size: 6) do
                for n <- 1..5 do
                  label do
                    text(content: "055#{n + 1}71#{n}", color: :red)
                    text(content: " - ")
                    text(content: "commit description #{n}")
                    text(content: " ")
                    text(content: "(#{n} hour(s) ago)", color: :green)
                  end
                end
              end
            end
          end
        end
      end

    # Week commits
    week =
      row do
        column(size: 6) do
          panel(title: " 🗓  This Week ", height: :fill) do
            label(content: "Project path: ~/Projects/Stone", color: :green)
            label()

            row do
              column(size: 6) do
                for n <- 1..9 do
                  label do
                    text(content: "055#{n + 1}71#{n}", color: :red)
                    text(content: " - ")
                    text(content: "commit description #{n}")
                    text(content: " ")
                    text(content: "(#{n} hour(s) ago)", color: :green)
                  end
                end
              end
            end
          end
        end
      end

    {today, week}
  end
end
