defmodule Feedback.ResponseController do
  use Feedback.Web, :controller
  alias Feedback.{Feedback, Response}

  plug :authenticate when action in [:create]

  def create(conn, %{"response" => response_params}) do
    feedback_id = response_params["feedback_id"]
    attrs
      =  response_params
      |> Map.new(fn {key, val} -> {String.to_atom(key), val} end)
      |> Map.delete(:feedback_id)

    feedback = Repo.get!(Feedback, feedback_id)
    changeset = Ecto.build_assoc(feedback, :response) |> Response.changeset(attrs)
    case Repo.insert(changeset) do
      {:ok, response} ->
        response = Repo.preload(response, :feedback)
        case get_referer(conn.req_headers) do
          "forum" ->
            send_response_email_if_exists(response.feedback)
            conn
            |> put_flash(:info, "Response sent successfully!")
            |> redirect(to: forum_path(conn, :forum_show, feedback.id))
          _other ->
            send_response_email_if_exists(response.feedback)
            conn
            |> put_flash(:info, "Response sent successfully!")
            |> redirect(to: feedback_path(conn, :show, feedback.permalink_string))
        end
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Oops! Something went wrong. Please try again")
        |> redirect(to: feedback_path(conn, :index))
    end
  end
end
