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

  def format_date(date) do
    date_today = DateTime.utc_now()
    same_day = date.day == date_today.day
    same_month = date.month == date_today.month
    same_year = date.year == date_today.year
    same_date = same_day && same_month && same_year
    case same_date do
      true -> "Today"
      false ->
        month = Integer.to_string(date.month)
        year = Integer.to_string(date.year)
        day = Integer.to_string(date.day)

        day <> "/" <> month <> "/" <> year
    end
  end

end
