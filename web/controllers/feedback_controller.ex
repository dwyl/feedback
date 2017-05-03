defmodule Feedback.FeedbackController do
  use Feedback.Web, :controller
  alias Feedback.Feedback

  plug :authenticate when action in [:index]

  def index(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    feedback = Enum.filter(raw_feedback, fn item -> item.response == nil end)
    responded_feedback = Enum.filter(raw_feedback, fn item -> item.response != nil end)
    render conn, "index.html", feedback: feedback, responded_feedback: responded_feedback
  end

  def new(conn, _params) do
    changeset = Feedback.changeset(%Feedback{})
    render conn, "new.html", changeset: changeset
  end

  def show(conn, %{"id" => permalink}) do
    case Repo.get_by(Feedback, permalink_string: permalink) do
      nil ->
        conn
        |> put_flash(:error, "That piece of feedback doesn't exist")
        |> redirect(to: page_path(conn, :index))
      feedback ->
        changeset = Feedback.changeset(feedback)
        render conn, "show.html", feedback: feedback, changeset: changeset
    end
  end

  def update(conn, %{"id" => id, "feedback" => feedback_params}) do
    feedback = Repo.get!(Feedback, id)
    changeset = Feedback.changeset(feedback, feedback_params)
    case Repo.update(changeset) do
      {:ok, feedback} ->
        conn
        |> put_flash(:info, "Success!")
        |> redirect(to: feedback_path(conn, :show, feedback.permalink_string))
      {:error, changeset} ->
        render conn, "show.html", feedback: feedback, changeset: changeset
    end
  end

  def create(conn, %{"feedback" => params}) do
    permalink_string = generate_permalink_string(24)
    feedback_params = Map.put(params, "permalink_string", permalink_string)
    changeset = Feedback.changeset(%Feedback{}, feedback_params)
    case Repo.insert(changeset) do
      {:ok, feedback} ->
        conn
        |> put_flash(:info, "Thank you so much for your feedback!")
        |> redirect(to: feedback_path(conn, :show, feedback))
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
