defmodule Feedback.Email do
  use Bamboo.Phoenix, view: Feedback.FeedbackView

  def send_email(to_email_address, subject, message) do
    new_email()
    |> to(to_email_address)
    |> from(System.get_env("ADMIN_EMAIL")) # also needs to be a validated email
    |> subject(subject)
    |> text_body(message)
  end
end
