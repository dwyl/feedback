defmodule Feedback.PageController do
  use Feedback.Web, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: feedback_path(conn, :new))
  end
end
