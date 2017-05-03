defmodule Feedback.PageControllerTest do
  use Feedback.ConnCase

  test "GET / not logged in", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn, 302) =~ "/feedback/new"
  end

  test "GET / logged in", %{conn: conn} do
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, "/"
    assert redirected_to(conn, 302) =~ "/feedback"
  end
end
