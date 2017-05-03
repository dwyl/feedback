defmodule Feedback.FeedbackController do
  use Feedback.Web, :controller
  alias Feedback.Feedback

  plug :authenticate when action in [:index]

  def index(conn, _params) do
    feedback = Repo.all(Feedback)
    render conn, "index.html", feedback: feedback
  end

  def new(conn, _params) do
    changeset = Feedback.changeset(%Feedback{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"feedback" => params}) do
    permalink_string = generate_permalink_string(32)
    feedback_params = Map.put(params, "permalink_string", permalink_string)
    changeset = Feedback.changeset(%Feedback{}, feedback_params)
    case Repo.insert(changeset) do
      {:ok, _feedback} ->
        conn
        |> put_flash(:info, "Thank you so much for your feedback!")
        |> redirect(to: feedback_path(conn, :new))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
    conn
    |> redirect(to: feedback_path(conn, :new))
  end

  defp generate_permalink_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end


end
