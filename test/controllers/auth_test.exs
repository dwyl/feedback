defmodule Feedback.AuthTest do
  use Feedback.ConnCase, async: false

  alias Feedback.{Auth, Router, User}

  describe "auth controller" do
    setup %{conn: conn} do
      conn =
        conn
        |> bypass_through(Router, :browser)
        |> get("/")

      {:ok, %{conn: conn}}
    end

    test "testing init function", do: assert Auth.init([repo: 1])

    test "authenticate_user halts when no current_user exists", %{conn: conn} do
      conn = Auth.authenticate(conn, [])

      assert conn.halted
    end

    test "authenticate continues when the current_user exists", %{conn: conn} do
      conn =
        conn
        |> assign(:current_user, %User{})
        |> Auth.authenticate([])
      refute conn.halted
    end

    test "login puts the user in the session", %{conn: conn} do
      login_conn =
        conn
        |> Auth.login(%User{id: id().user})
        |> send_resp(:ok, "")
      next_conn = get(login_conn, "/")
      assert get_session(next_conn, :user_id) == id().user
    end

    test "logout drops the session", %{conn: conn} do
      logout_conn =
        conn
        |> put_session(:user_id, id().user)
        |> Auth.logout()
        |> send_resp(:ok, "")

      next_conn = get(logout_conn, "/")
      refute get_session(next_conn, :user_id)
    end

    test "call places user from session into assigns", %{conn: conn} do
      user = insert_validated_user()
      conn =
        conn
        |> put_session(:user_id, user.id)
        |> Auth.call(Repo)

      assert conn.assigns.current_user.id == user.id
    end

    test "call returns conn when current_user is assigned", %{conn: conn} do
      user = insert_validated_user()
      conn =
        conn
        |> assign(:current_user, Repo.get_by(User, email: "email@test.com"))
        |> put_session(:user_id, user.id)
        |> Auth.call(Repo)

      assert conn.assigns.current_user.id == user.id
    end

    test "call with no session sets current_user assign to nil", %{conn: conn} do
      conn = Auth.call(conn, Repo)
      assert conn.assigns.current_user == nil
    end

    test "login with a valid username and pass", %{conn: conn} do
      user = insert_validated_user()
      {:ok, conn} =
        Auth.login_by_email_and_pass(conn, "email@test.com", "supersecret", repo: Repo)

      assert conn.assigns.current_user.id == user.id
    end

    test "login with a not found user", %{conn: conn} do
      assert {:error, :not_found, _conn} =
        Auth.login_by_email_and_pass(conn, "notemail@nottest.com", "supersecret", repo: Repo)
    end

    test "login with password mismatch", %{conn: conn} do
      insert_validated_user()
      assert {:error, :unauthorized, _conn} =
        Auth.login_by_email_and_pass(conn, "email@test.com", "wrong", repo: Repo)
    end
  end
end
