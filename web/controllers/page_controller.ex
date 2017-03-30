defmodule Feedback.PageController do
  use Feedback.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
