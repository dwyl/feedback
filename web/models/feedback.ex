defmodule Feedback.Feedback do
  use Feedback.Web, :model

  schema "feedback" do
    field :item, :string
    field :response, :string
    field :submitter_email, :string
    field :permalink_string, :string
    field :mood, :string
    field :public, :boolean
    field :responded_at, :date
    field :edit, :boolean
    field :edited, :boolean

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [
      :item,
      :response,
      :submitter_email,
      :permalink_string,
      :mood,
      :public,
      :responded_at,
      :edit,
      :edited])
    |> validate_format(:submitter_email, ~r/@/)
    |> validate_length(:response, min: 2)
    |> validate_required([:item, :permalink_string, :mood])
  end

  defimpl Phoenix.Param, for: Feedback.Feedback do
    def to_param(%{permalink_string: permalink_string}) do
      "#{permalink_string}"
    end
  end
end
