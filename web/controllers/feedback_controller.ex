defmodule Feedback.FeedbackController do
  use Feedback.Web, :controller
  alias Feedback.{Feedback, LayoutView}

  plug :authenticate when action in [:index, :angry, :upset, :neutral, :happy, :delighted]

  def index(conn, _params) do

    happy_feedback = get_feedback("happy")
    delighted_feedback = get_feedback("delighted")
    neutral_feedback = get_feedback("neutral")
    angry_feedback = get_feedback("angry")
    sad_feedback = get_feedback("sad")

    emotions = [
      {"delighted", delighted_feedback},
      {"happy", happy_feedback},
      {"neutral", neutral_feedback},
      {"sad", sad_feedback},
      {"angry", angry_feedback}]

    render conn, "index.html", layout: {LayoutView, "nav.html"}, emotions: emotions

  end

  def new(conn, _params) do
    changeset = Feedback.changeset(%Feedback{})
    emotions = ["angry", "sad", "neutral", "happy", "delighted"]
    render conn, "new.html", layout: {LayoutView, "index.html"}, changeset: changeset, emotions: emotions
  end

  def show(conn, %{"id" => permalink}) do
    case Repo.get_by(Feedback, permalink_string: permalink) do
      nil ->
        conn
        |> put_flash(:error, "That piece of feedback doesn't exist")
        |> redirect(to: page_path(conn, :index))
      feedback ->
        changeset = Feedback.changeset(feedback)
        render conn, "show.html", layout: {LayoutView, "nav.html"}, feedback: feedback, changeset: changeset
    end
  end

  def update(conn, %{"id" => id, "feedback" => feedback_params}) do
    feedback = Repo.get!(Feedback, id)
    changeset = Feedback.changeset(feedback, feedback_params)
    case Repo.update(changeset) do
      {:ok, feedback} ->
        case get_referer(conn.req_headers) do
          "forum" ->
            conn
            |> put_flash(:info, "Success!")
            |> redirect(to: forum_path(conn, :forum_show, feedback.id))
          _other ->
            conn
            |> put_flash(:info, "Success!")
            |> redirect(to: feedback_path(conn, :show, feedback.permalink_string))
        end

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

  # def forum(conn, _params) do
  #   raw_feedback = Repo.all(Feedback)
  #   public_feedback =
  #     raw_feedback
  #     |> Enum.filter(fn item -> item.public end)
  #     |> sort_by_ascending_date()
  #   render conn, "forum.html", layout: {LayoutView, "forum.html"}, public_feedback: public_feedback
  # end
  #
  # def forum_show(conn, %{"id" => permalink}) do
  #   case Repo.get_by(Feedback, permalink_string: permalink) do
  #     nil ->
  #       conn
  #       |> put_flash(:error, "That piece of feedback doesn't exist")
  #       |> redirect(to: page_path(conn, :index))
  #     feedback ->
  #       changeset = Feedback.changeset(feedback)
  #       render conn, "forum_show.html", layout: {LayoutView, "forum.html"}, feedback: feedback, changeset: changeset
  #   end
  # end

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


  # defp generate_permalink_string(length) do
  #   :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  # end
  #
  # def sort_by_ascending_date(enum) do
  #   enum |> Enum.sort(&(&1.inserted_at >= &2.inserted_at))
  # end
  #
  # defp format_error(changeset) do
  #   errors = changeset.errors
  #   case length(errors) do
  #     1 ->
  #       {key, _} = Enum.at(errors, 0)
  #       case key do
  #         :item ->
  #           "Make sure you write something in the feedback textbox"
  #         :mood ->
  #           "Make sure you select your mood"
  #       end
  #     2 ->
  #       "To leave feedback, select your mood and write your thoughts in the
  #       textbox"
  #   end
  # end
  #
  # defp get_feedback(emotion) do
  #  raw_feedback = Repo.all(Feedback)
  #  feedback =
  #  raw_feedback
  #  |> Enum.filter(fn item -> item.response == nil end)
  #  |> Enum.filter(fn item -> item.mood == emotion end)
  #  |> sort_by_ascending_date()
  #
  #  feedback
  # end
  #
  # defp get_responded_feedback(emotion) do
  #   raw_feedback = Repo.all(Feedback)
  #   responded_feedback =
  #   raw_feedback
  #   |> Enum.filter(fn item -> item.response != nil end)
  #   |> Enum.filter(fn item -> item.mood == emotion end)
  #   |> sort_by_ascending_date()
  #
  #   responded_feedback
  # end
  #
  # defp get_referer(headers) do
  #   [{_header, value}] = Enum.filter(headers, fn {header, _value} -> header == "referer" end)
  #   path = Enum.at(String.split(value, "/"), 3)
  #   path
  # end

end
