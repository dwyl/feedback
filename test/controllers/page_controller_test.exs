defmodule Feedback.PageControllerTest do
  use Feedback.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn, 302) =~ "/feedback/new"
  end
end
