defmodule Feedback.FeedbackController do
  use Feedback.Web, :controller
  alias Feedback.Feedback

  plug :authenticate when action in [:index, :angry, :upset, :neutral, :happy, :delighted]

  def index(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    happy_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "happy" end)
      |> sort_by_ascending_date()

    delighted_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "delighted" end)
      |> sort_by_ascending_date()

    neutral_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "neutral" end)
      |> sort_by_ascending_date()

    angry_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "angry" end)
      |> sort_by_ascending_date()

    sad_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "sad" end)
      |> sort_by_ascending_date()

    emotions = [
      {"delighted", delighted_feedback},
      {"happy", happy_feedback},
      {"neutral", neutral_feedback},
      {"sad", sad_feedback},
      {"angry", angry_feedback}]

    render conn, "index.html", emotions: emotions

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
    raw_feedback = Repo.all(Feedback)
    happy_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "happy" end)
      |> sort_by_ascending_date()

    responded_happy_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response != nil end)
      |> Enum.filter(fn item -> item.mood == "happy" end)
      |> sort_by_ascending_date()

    render conn, "happy.html", happy_feedback: happy_feedback, responded_happy_feedback: responded_happy_feedback
  end


  def delighted(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    delighted_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "delighted" end)
      |> sort_by_ascending_date()

    responded_delighted_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response != nil end)
      |> Enum.filter(fn item -> item.mood == "delighted" end)
      |> sort_by_ascending_date()

    render conn, "delighted.html", delighted_feedback: delighted_feedback, responded_delighted_feedback: responded_delighted_feedback
  end

  def neutral(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    neutral_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "neutral" end)
      |> sort_by_ascending_date()

    responded_neutral_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response != nil end)
      |> Enum.filter(fn item -> item.mood == "neutral" end)
      |> sort_by_ascending_date()

    render conn, "neutral.html", neutral_feedback: neutral_feedback, responded_neutral_feedback: responded_neutral_feedback
  end

  def sad(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    sad_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "sad" end)
      |> sort_by_ascending_date()

    responded_sad_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response != nil end)
      |> Enum.filter(fn item -> item.mood == "sad" end)
      |> sort_by_ascending_date()

    render conn, "sad.html", sad_feedback: sad_feedback, responded_sad_feedback: responded_sad_feedback
  end

  def angry(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    angry_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response == nil end)
      |> Enum.filter(fn item -> item.mood == "angry" end)
      |> sort_by_ascending_date()

    responded_angry_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.response != nil end)
      |> Enum.filter(fn item -> item.mood == "angry" end)
      |> sort_by_ascending_date()

    render conn, "angry.html", angry_feedback: angry_feedback, responded_angry_feedback: responded_angry_feedback
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
