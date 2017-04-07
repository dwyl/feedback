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

  test "/feedback", %{conn: conn} do
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, feedback_path(conn, :index)
    assert html_response(conn, 200) =~ "Feedback Dashboard"
  end

  test "/feedback/:id", %{conn: conn} do
    feedback = insert_feedback()
    conn = get conn, feedback_path(conn, :show, feedback.permalink_string)
    assert html_response(conn, 200) =~ "Feedback"
  end

  test "/feedback/:id invalid", %{conn: conn} do
    conn = get conn, feedback_path(conn, :show, 1)
    assert redirected_to(conn, 302) =~ "/"
  end

  test "/feedback/:id update", %{conn: conn} do
    feedback = insert_feedback()
    conn = put conn, feedback_path(conn, :update, feedback.id, %{"feedback" => %{"response" => "response"}})
    assert redirected_to(conn, 302) =~ "/feedback/#{feedback.permalink_string}"
  end

  test "/feedback/:id update error", %{conn: conn} do
    feedback = insert_feedback()
    conn = put conn, feedback_path(conn, :update, feedback.id, %{"feedback" => %{"submitter_email" => "invalid_email_format"}})
    assert html_response(conn, 200) =~ "feedback"
  end
end
