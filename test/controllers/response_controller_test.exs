defmodule Feedback.ResponseControllerTest do
  use Feedback.ConnCase, async: false
  alias Feedback.{Mailer}

  import Mock

  test "response/create valid from forum", %{conn: conn} do
    with_mock Mailer, [deliver_later: fn(_) -> nil end] do
      Mix.env(:test)
      user = insert_validated_user()
      conn =
        conn
        |> assign(:current_user, user)
        |> put_req_header("referer", "http://localhost:4000/forum")
      feedback = insert_feedback()
      conn = post conn, response_path(conn, :create, %{"response" => %{response: "response", feedback_id: feedback.id}})
      [{_header, location}] = Enum.filter(conn.resp_headers, fn {header, _value}  -> header == "location" end)
      assert redirected_to(conn, 302) =~ location
    end
  end

  test "response/create valid from feedback", %{conn: conn} do
    with_mock Mailer, [deliver_later: fn(_) -> nil end] do
      Mix.env(:dev)
      user = insert_validated_user()
      conn =
        conn
        |> assign(:current_user, user)
        |> put_req_header("referer", "http://localhost:4000/feedback")
      feedback = insert_feedback(%{submitter_email: "test@email.com"})
      conn = post conn, response_path(conn, :create, %{"response" => %{response: "response", feedback_id: feedback.id}})
      [{_header, location}] = Enum.filter(conn.resp_headers, fn {header, _value}  -> header == "location" end)
      assert redirected_to(conn, 302) =~ location
    end
  end

  test "response/create invalid", %{conn: conn} do
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
      |> put_req_header("referer", "http://localhost:4000/feedback")
    feedback = insert_feedback()
    conn = post conn, response_path(conn, :create, %{"response" => %{response: "", feedback_id: feedback.id}})
    [{_header, location}] = Enum.filter(conn.resp_headers, fn {header, _value}  -> header == "location" end)
    assert redirected_to(conn, 302) =~ location
  end

  test "response/:id update feedback", %{conn: conn} do
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
      |> put_req_header("referer", "http://localhost:4000/feedback")
    feedback = insert_feedback()
    response = insert_response(%{feedback_id: feedback.id})
    conn = post conn, response_path(conn, :update, response, %{"response" => %{"response" => "changed my mind"}})
    assert redirected_to(conn, 302) =~ "/feedback/#{feedback.permalink_string}"
  end

  test "response/:id update forum", %{conn: conn} do
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
      |> put_req_header("referer", "http://localhost:4000/forum")
    feedback = insert_feedback()
    response = insert_response(%{feedback_id: feedback.id})
    conn = post conn, response_path(conn, :update, response, %{"response" => %{"response" => "changed my mind"}})
    assert redirected_to(conn, 302) =~ "/forum/#{feedback.id}"
  end

  test "response/:id update error", %{conn: conn} do
    user = insert_validated_user()
    conn =
      conn
      |> assign(:current_user, user)
      |> put_req_header("referer", "http://localhost:4000/forum")
    feedback = insert_feedback()
    response = insert_response(%{feedback_id: feedback.id})
    conn = post conn, response_path(conn, :update, response, %{"response" => %{"response" => ""}})
    assert redirected_to(conn, 302) =~ "/feedback/#{feedback.permalink_string}"
  end
end
