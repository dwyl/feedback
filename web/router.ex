defmodule Feedback.Router do
  use Feedback.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Feedback.Auth, repo: Feedback.Repo
  end

  scope "/", Feedback do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/feedback", FeedbackController, only: [:index, :new, :create, :show, :update]
    resources "/session", SessionController, only: [:new, :create, :delete]
  end

end
