defmodule Feedback.FeedbackControllerTest do
  use Feedback.ConnCase, async: false
  alias Feedback.{Email, Mailer}

  import Mock

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
    conn =
      conn
      |> put_req_header("referer", "http://localhost:4000/forum")
    conn = put conn, feedback_path(conn, :update, feedback.id, %{"feedback" => %{"response" => "response"}})
    assert redirected_to(conn, 302) =~ "/forum/#{feedback.id}"
  end

  test "/feedback/:id update different request header", %{conn: conn} do
    feedback = insert_feedback(%{submitter_email: "test@email.com"})
    with_mock Mailer, [deliver_now: fn(_) -> nil end] do
      conn =
        conn
        |> put_req_header("referer", "http://localhost:4000/feedback")
      conn = put conn, feedback_path(conn, :update, feedback.id, %{"feedback" => %{"response" => "response"}})
      assert redirected_to(conn, 302) =~ "/feedback/#{feedback.permalink_string}"
    end
  end

  test "/feedback/:id update error email", %{conn: conn} do
    feedback = insert_feedback()
    conn = put conn, feedback_path(conn, :update, feedback.id, %{"feedback" => %{"submitter_email" => "invalid_email_format"}})
    assert html_response(conn, 200) =~ "feedback"
  end

  test "/feedback/:id update error response", %{conn: conn} do
    feedback = insert_feedback()
    conn =
      conn
      |> put_req_header("referer", "http://localhost:4000/feedback")
    conn = put conn, feedback_path(conn, :update, feedback.id, %{"feedback" => %{"response" => "a"}})
    assert html_response(conn, 200) =~ "feedback"
  end

  test "/feedback/:id update email submit", %{conn: conn} do
    feedback = insert_feedback()
    conn = put conn, feedback_path(conn, :update, feedback.id, %{"feedback" => %{"submitter_email" => "test@email.com"}})
    assert redirected_to(conn, 302) =~ "/feedback/#{feedback.permalink_string}"
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

  test "strucuture of email is ok" do
    email = Email.send_email("test@email.com", "Welcome", "Hello there")
    assert email.to == "test@email.com"
    assert email.subject == "Welcome"
    assert email.text_body =~ "Hello there"
  end
end
