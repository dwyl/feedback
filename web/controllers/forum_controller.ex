defmodule Feedback.ForumController do
  use Feedback.Web, :controller
  alias Feedback.{Feedback, Response, LayoutView}

  def forum(conn, _params) do
    raw_feedback = Repo.all(Feedback)
    public_feedback =
      raw_feedback
      |> Enum.filter(fn item -> item.public end)
      |> sort_by_ascending_date()
      |> Repo.preload(:response)
    render conn, "forum.html", layout: {LayoutView, "forum.html"}, public_feedback: public_feedback
  end

  def forum_show(conn, %{"id" => id}) do
    case Repo.get_by(Feedback, id: id) do
      nil ->
        conn
        |> put_flash(:error, "That piece of feedback doesn't exist")
        |> redirect(to: page_path(conn, :index))
      feedback ->
        feedback = Repo.preload(feedback, :response)
        changeset = Response.changeset(%Response{})
        render conn, "forum_show.html", layout: {LayoutView, "forum.html"}, feedback: feedback, changeset: changeset
    end
  end
end
