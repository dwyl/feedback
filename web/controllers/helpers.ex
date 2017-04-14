defmodule Feedback.Controllers.Helpers do
  alias Feedback.{Repo, Feedback}

  def generate_permalink_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def sort_by_ascending_date(enum) do
    enum |> Enum.sort(&(&1.inserted_at >= &2.inserted_at))
  end

  def format_error(changeset) do
    errors = changeset.errors
    case length(errors) do
      1 ->
        {key, _} = Enum.at(errors, 0)
        case key do
          :item ->
            "Make sure you write something in the feedback textbox"
          :mood ->
            "Make sure you select your mood"
        end
      2 ->
        "To leave feedback, select your mood and write your thoughts in the
        textbox"
    end
  end

  def get_feedback(emotion) do
   raw_feedback = Repo.all(Feedback)
   feedback =
   raw_feedback
   |> Enum.filter(fn item -> item.response == nil end)
   |> Enum.filter(fn item -> item.mood == emotion end)
   |> sort_by_ascending_date()

   feedback
  end

  def get_responded_feedback(emotion) do
    raw_feedback = Repo.all(Feedback)
    responded_feedback =
    raw_feedback
    |> Enum.filter(fn item -> item.response != nil end)
    |> Enum.filter(fn item -> item.mood == emotion end)
    |> sort_by_ascending_date()

    responded_feedback
  end

  def get_referer(headers) do
    [{_header, value}] = Enum.filter(headers, fn {header, _value} -> header == "referer" end)
    path = Enum.at(String.split(value, "/"), 3)
    path
  end

end
