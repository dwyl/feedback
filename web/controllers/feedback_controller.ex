defmodule Feedback.FeedbackController do
  use Feedback.Web, :controller
  alias Feedback.Feedback

  plug :authenticate when action in [:index]

  def index(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> sort_by_ascending_date()

    responded_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response != nil end)
      |> sort_by_ascending_date()

    render conn, "index.html", feedback: feedback, responded_feedback: responded_feedback
  end

  def new(conn, _params) do
    changeset = Feedback.changeset(%Feedback{})
    emotions = ["angry", "sad", "neutral", "happy", "delighted"]
    render conn, "new.html", changeset: changeset, emotions: emotions
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
        error = format_error(changeset)
        conn
        |> put_flash(:error, "Oops! Something went wrong. #{error}")
        |> redirect(to: feedback_path(conn, :new))
    end
  end

  defp generate_permalink_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  defp sort_by_ascending_date(enum) do
    enum |> Enum.sort(&(&1.inserted_at >= &2.inserted_at))
  end

  defp format_error(changeset) do
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

end
