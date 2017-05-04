defmodule Feedback.UserTest do
  use Feedback.ModelCase
  alias Feedback.User
  alias Comeonin.Bcrypt

  @valid_attrs %{
     email: "email@test.com",
     password: "secretshhh",
     password_hash: Bcrypt.hashpwsalt("secretshhh"),
     first_name: "First",
     last_name: "Last"
   }
   @invalid_attrs %{email: "test@test.com"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "registration_changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "registration_changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "user schema" do
     actual = User.__schema__(:fields)
     expected = [
       :id,
       :first_name,
       :last_name,
       :email,
       :password_hash,
       :inserted_at,
       :updated_at
     ]
     assert actual == expected
   end
end
