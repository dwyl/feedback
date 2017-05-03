defmodule Feedback.FeedbackControllerTest do
  use Feedback.ConnCase, async: false

  test "/feedback/new", %{conn: conn} do
    conn = get conn, "/feedback/new"
    assert html_response(conn, 200) =~ "Help us be better"
  end

  test "/feedback/create valid", %{conn: conn} do
    conn = post conn, feedback_path(conn, :create, %{"feedback" => %{item: "test", mood: "happy"}})
    [{_header, location}] = Enum.filter(conn.resp_headers, fn {header, _value}  -> header == "location" end)
    assert redirected_to(conn, 302) =~ location
  end

  test "/feedback/create", %{conn: conn} do
    conn = post conn, feedback_path(conn, :create, %{"feedback" => %{item: "test"}})
    assert redirected_to(conn, 302) =~ "/feedback/new"
  end

  test "/feedback/create invalid", %{conn: conn} do
    conn = post conn, feedback_path(conn, :create, %{"feedback" => %{item: "", permalink_string: ""}})
    assert redirected_to(conn, 302) =~ "/feedback/new"
  end

  test "/feedback", %{conn: conn} do
    insert_feedback()
    insert_feedback(%{id: 2, response: "Response"})
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, feedback_path(conn, :index)
    assert html_response(conn, 200) =~ "category"
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

  test "/happy", %{conn: conn} do
    insert_feedback()
    insert_feedback(%{response: "response"})
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, feedback_path(conn, :happy)
    assert html_response(conn, 200) =~ "happy"
  end

  test "/delighted", %{conn: conn} do
    insert_feedback(%{mood: "delighted"})
    insert_feedback(%{response: "response"})
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, feedback_path(conn, :delighted)
    assert html_response(conn, 200) =~ "delighted"
  end

  test "/neutral", %{conn: conn} do
    insert_feedback(%{mood: "neutral"})
    insert_feedback(%{response: "response"})
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, feedback_path(conn, :neutral)
    assert html_response(conn, 200) =~ "neutral"
  end

  test "/sad", %{conn: conn} do
    insert_feedback(%{mood: "sad"})
    insert_feedback(%{response: "response"})
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, feedback_path(conn, :sad)
    assert html_response(conn, 200) =~ "sad"
  end

  test "/angry", %{conn: conn} do
    insert_feedback(%{mood: "angry"})
    insert_feedback(%{response: "response"})
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
    conn = get conn, feedback_path(conn, :angry)
    assert html_response(conn, 200) =~ "angry"
  end
end
