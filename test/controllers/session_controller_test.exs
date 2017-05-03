defmodule Feedback.SessionControllerTest do
  use Feedback.ConnCase, async: false

  alias Feedback.User

  describe "session routes that don't need authentication" do
    test "Get /session/new", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "session routes that need authentication" do
    setup do
      insert_validated_user()

      conn = assign(build_conn(), :current_user, Repo.get(User, id().user))
      {:ok, conn: conn}
    end

    test "Get /session/new logged in", %{conn: conn} do
      changes = %{first_name: "First",
          last_name: "Last",
          email: "email@test2.com",
          password: "supersecret",
          id: 2}

      user =
        %User{}
        |> User.registration_changeset(changes)
        |> Repo.insert!
      conn =
        conn
        |> assign(:current_user, user)
      conn = get conn, session_path(conn, :new)
      assert redirected_to(conn, 302) =~ "/feedback"
    end

    test "Login: Valid session /session/new", %{conn: conn} do
      conn = post conn, session_path(conn, :create,
      %{"session" => %{"email" => "email@test.com", "password" => "supersecret"}})
      assert redirected_to(conn, 302) =~ "/feedback"
    end

    test "Login: Invalid session /sessions/new", %{conn: conn} do
      conn = post conn, session_path(conn, :create,
      %{"session" => %{"email" => "invalid@test.com", "password" => "invalid"}})
      assert html_response(conn, 302) =~ "/session/new"
    end

    test "Login: Invalid password", %{conn: conn} do
      conn = post conn, session_path(conn, :create,
      %{"session" => %{"email" => "email@test.com", "password" => "invalid"}})
      assert html_response(conn, 302) =~ "/session/new"
    end

    test "Logout", %{conn: conn} do
      changes = %{first_name: "First",
          last_name: "Last",
          email: "email@test1.com",
          password: "supersecret",
          id: 1}

      user =
        %User{}
        |> User.registration_changeset(changes)
        |> Repo.insert!
      conn =
        conn
        |> assign(:current_user, user)
      conn = delete conn, session_path(conn, :delete, conn.assigns.current_user)
      assert redirected_to(conn, 302) =~ "/"
    end
  end
end
