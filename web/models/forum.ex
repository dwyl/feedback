defmodule Feedback.Forum do
  use Feedback.Web, :model

  defimpl Phoenix.Param, for: Feedback.Forum do
    def to_param(%{id: id}) do
      "#{id}"
    end
  end
end
