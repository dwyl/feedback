defmodule Feedback.TestHelpers do
  alias Feedback.{Repo, User, Feedback, Response}

  @user_id 1
  @feedback_id 1
  @response_id 1

  def id() do
    %{
      user: @user_id,
      feedback: @feedback_id,
      response: @response_id
    }
  end

  def insert_validated_user(attrs \\ %{}) do
    changes = Map.merge(
      %{first_name: "First",
        last_name: "Last",
        email: "email@test.com",
        password: "supersecret",
        id: @user_id},
        attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!
  end

  def insert_feedback(attrs \\ %{}) do
    changes = Map.merge(
      %{item: "Feedback",
        permalink_string: "thisisapermalink",
        mood: "happy",
        id: @feedback_id},
        attrs)

    %Feedback{}
    |> Feedback.changeset(changes)
    |> Repo.insert!
  end

  def insert_response(attrs \\ %{}) do
    changes = Map.merge(
      %{response: "Response",
        feedback_id: @feedback_id,
        id: @response_id},
        attrs)

    %Response{}
    |> Response.changeset(changes)
    |> Repo.insert!
  end
end
