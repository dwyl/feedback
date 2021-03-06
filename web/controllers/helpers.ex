defmodule Feedback.Controllers.Helpers do
  alias Feedback.{Repo, Feedback, Email, Mailer}

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
   raw_feedback = Repo.all(Feedback) |> Repo.preload(:response)
   feedback =
   raw_feedback
   |> Enum.filter(fn item -> item.response == nil end)
   |> Enum.filter(fn item -> item.mood == emotion end)
   |> sort_by_ascending_date()

   feedback
  end

  def get_responded_feedback(emotion) do
    raw_feedback = Repo.all(Feedback) |> Repo.preload(:response)
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

  def get_base_url() do
    dev_env? = Mix.env == :dev
    case dev_env? do
      true -> System.get_env("DEV_URL")
      false -> System.get_env("PROD_URL")
    end
  end

  def send_response_email_if_exists(feedback) do
    link = "#{get_base_url()}/feedback/#{feedback.permalink_string}"
    subject = "Feedback Response"
    message = "Hi there! There has been a response to your feedback. Follow this link #{link} to view it."
    if feedback.submitter_email != nil do
      Email.send_email(feedback.submitter_email, subject, message)
      |> Mailer.deliver_later()
    end
  end

  def send_feedback_email(feedback) do
    link = "#{get_base_url()}/feedback/#{feedback.permalink_string}"
    subject = "New Feedback"
    message = "You have a new piece of #{feedback.mood} feedback: \"#{feedback.item}\". Follow this link #{link} to respond."
    Email.send_email(System.get_env("ADMIN_EMAIL"), subject, message)
    |> Mailer.deliver_later()
  end

end
