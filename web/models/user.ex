defmodule Feedback.User do
  use Feedback.Web, :model
  alias Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_required([:email, :password, :first_name, :last_name])
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> validate_password(params)
    |> put_pass_hash()
  end

  def validate_password(changeset, params) do
    changeset
    |> cast(params, [:password, :email])
    |> validate_length(:password, min: 6, max: 100)
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
