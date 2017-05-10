defmodule Feedback.ForumControllerTest do
  use Feedback.ConnCase, async: false

  test "/forum", %{conn: conn} do
    insert_feedback(%{public: true})
    conn = get conn, forum_path(conn, :forum)
    assert html_response(conn, 200) =~ "Forum"
  end

  test "/forum/:id", %{conn: conn} do
    feedback = insert_feedback(%{public: true})
    conn = get conn, forum_path(conn, :forum_show, feedback.id)
    assert html_response(conn, 200) =~ "Feedback"
  end

  test "/forum/:id invalid", %{conn: conn} do
    conn = get conn, forum_path(conn, :forum_show, 1)
    assert redirected_to(conn, 302) =~ "/"
  end
end
