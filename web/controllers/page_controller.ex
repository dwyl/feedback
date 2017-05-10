defmodule Feedback.PageController do
  use Feedback.Web, :controller

  def index(conn, _params) do
    case conn.assigns.current_user do
      nil ->
        conn
        |> redirect(to: feedback_path(conn, :new))
      _user ->
        conn
        |> redirect(to: feedback_path(conn, :index))
    end
  end
end
