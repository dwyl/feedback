defmodule Feedback.FeedbackControllerTest do
  use Feedback.ConnCase, async: false

  test "/feedback/new", %{conn: conn} do
    conn = get conn, "/feedback/new"
    assert html_response(conn, 200) =~ "Help us learn and grow"
  end

  test "/feedback/create", %{conn: conn} do
    conn = post conn, feedback_path(conn, :create, %{"feedback" => %{item: "test", permalink_string: "1r5AY5HKgD4Efp-yovMrltpe3AWYKWVL"}})
    assert redirected_to(conn, 302) =~ "/feedback/new"
  end

  test "/feedback/create invalid", %{conn: conn} do
    conn = post conn, feedback_path(conn, :create, %{"feedback" => %{item: "", permalink_string: ""}})
    assert redirected_to(conn, 302) =~ "/feedback/new"
  end
end
