defmodule Feedback.SessionController do
  use Feedback.Web, :controller
  alias Feedback.User

  def new(conn, _params) do
    case conn.assigns.current_user do
      nil ->
        changeset = User.changeset(%User{})
        render conn, "new.html", changeset: changeset
      _user ->
        conn
        |> put_flash(:info, "You are already logged in!")
        |> redirect(to: feedback_path(conn, :index))
    end

  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Feedback.Auth.login_by_email_and_pass(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome Back!")
        |> redirect(to: feedback_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> Feedback.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
