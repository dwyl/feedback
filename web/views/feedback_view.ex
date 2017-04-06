defmodule Feedback.FeedbackView do
  use Feedback.Web, :view

  def truncate_text(text, text_length) do
    case String.length(text) > text_length do
      true ->
        truncated_text = String.slice(text, 0, text_length)
        clean_text = remove_whitespace(truncated_text)
        clean_text <> "..."
      false ->
        text
    end
  end

  defp remove_whitespace(text) do
    case String.last(text) == " " do
      true ->
        cleaner_string = String.slice(text, 0, String.length(text) - 1)
        remove_whitespace(cleaner_string)
      false ->
        text
    end
  end
end
