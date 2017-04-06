defmodule Feedback.TestHelpers do
  alias Feedback.{Repo, User}

  @user_id 1

  def id() do
    %{user: @user_id}
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
end
