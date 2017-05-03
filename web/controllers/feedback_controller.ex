defmodule Feedback.FeedbackController do
  use Feedback.Web, :controller
  alias Feedback.{Feedback, LayoutView, Response}

  plug :authenticate when action in [:index, :angry, :upset, :neutral, :happy, :delighted]

  def index(conn, _params) do

    happy_feedback = get_feedback("happy")
    delighted_feedback = get_feedback("delighted")
    neutral_feedback = get_feedback("neutral")
    confused_feedback = get_feedback("confused")
    angry_feedback = get_feedback("angry")
    sad_feedback = get_feedback("sad")

    emotions = [
      {"delighted", delighted_feedback},
      {"happy", happy_feedback},
      {"neutral", neutral_feedback},
      {"confused", confused_feedback},
      {"sad", sad_feedback},
      {"angry", angry_feedback}]

    render conn, "index.html", layout: {LayoutView, "nav.html"}, emotions: emotions

  end

  def new(conn, _params) do
    changeset = Feedback.changeset(%Feedback{})
    emotions = ["angry", "sad", "confused", "neutral", "happy", "delighted"]
    render conn, "new.html", layout: {LayoutView, "index.html"}, changeset: changeset, emotions: emotions
  end

  def show(conn, %{"id" => permalink}) do
    case Repo.get_by(Feedback, permalink_string: permalink) do
      nil ->
        conn
        |> put_flash(:error, "That piece of feedback doesn't exist")
        |> redirect(to: page_path(conn, :index))
      feedback ->
        loaded_feedback = Repo.preload(feedback, :response)
        response_changeset = Response.changeset(%Response{})
        changeset = Feedback.changeset(feedback)
        render conn, "show.html", layout: {LayoutView, "nav.html"}, feedback: loaded_feedback, changeset: changeset, response_changeset: response_changeset
    end
  end

  def update(conn, %{"id" => id, "feedback" => feedback_params}) do
    feedback = Repo.get!(Feedback, id) |> Repo.preload(:response)
      case Map.has_key?(feedback_params, "submitter_email") do
        true ->
        changeset = Feedback.changeset(feedback, feedback_params)
        case Repo.update(changeset) do
          {:ok, _email} ->
            conn
            |> put_flash(:info, "Email submitted successfully!")
            |> redirect(to: feedback_path(conn, :show, feedback.permalink_string))
          {:error, changeset} ->
            render conn, "show.html", feedback: feedback, changeset: changeset
        end
        false ->
          changeset = Feedback.changeset(feedback, feedback_params)
          case Repo.update(changeset) do
            {:ok, feedback} ->
              conn
              |> redirect(to: feedback_path(conn, :show, feedback.permalink_string))
            {:error, changeset} ->
              render conn, "show.html", feedback: feedback, changeset: changeset
          end
      end
  end

  def create(conn, %{"feedback" => params}) do
    permalink_string = generate_permalink_string(24)
    feedback_params = Map.put(params, "permalink_string", permalink_string)
    changeset = Feedback.changeset(%Feedback{}, feedback_params)
    case Repo.insert(changeset) do
      {:ok, feedback} ->
        send_feedback_email(feedback)
        conn
        |> put_flash(:info, "Thank you so much for your feedback!")
        |> redirect(to: feedback_path(conn, :show, feedback))
        |> halt()
      {:error, changeset} ->
        error = format_error(changeset)
        conn
        |> put_flash(:error, "Oops! Something went wrong. #{error}")
        |> redirect(to: feedback_path(conn, :new))
        |> halt()
    end
  end

  def happy(conn, _params) do
    feedback = get_feedback("happy")
    responded_feedback = get_responded_feedback("happy")

    render conn, "happy.html", layout: {LayoutView, "nav.html"}, feedback: feedback, responded_feedback: responded_feedback
  end


  def delighted(conn, _params) do
    feedback = get_feedback("delighted")
    responded_feedback = get_responded_feedback("delighted")

    render conn, "delighted.html", layout: {LayoutView, "nav.html"}, feedback: feedback, responded_feedback: responded_feedback
  end

  def neutral(conn, _params) do
    feedback = get_feedback("neutral")
    responded_feedback = get_responded_feedback("neutral")

    render conn, "neutral.html", layout: {LayoutView, "nav.html"}, feedback: feedback, responded_feedback: responded_feedback
  end

  def confused(conn, _params) do
    feedback = get_feedback("confused")
    responded_feedback = get_responded_feedback("confused")

    render conn, "confused.html", layout: {LayoutView, "nav.html"}, feedback: feedback, responded_feedback: responded_feedback
  end

  def sad(conn, _params) do
    feedback = get_feedback("sad")
    responded_feedback = get_responded_feedback("sad")

    render conn, "sad.html", layout: {LayoutView, "nav.html"}, feedback: feedback, responded_feedback: responded_feedback
  end

  def angry(conn, _params) do
    feedback = get_feedback("angry")
    responded_feedback = get_responded_feedback("angry")

    render conn, "angry.html", layout: {LayoutView, "nav.html"}, feedback: feedback, responded_feedback: responded_feedback
  end

end
