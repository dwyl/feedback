defmodule Feedback.Feedback do
  use Feedback.Web, :model

  schema "feedback" do
    field :item, :string
    field :response, :string
    field :responded, :boolean
    field :submitter_email, :string
    field :permalink_string, :string

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:item, :response, :responded, :submitter_email, :permalink_string])
    |> validate_format(:submitter_email, ~r/@/)
    |> validate_required([:item, :permalink_string])
  end

  defimpl Phoenix.Param, for: Feedback.Feedback do
    def to_param(%{permalink_string: permalink_string}) do
      "#{permalink_string}"
    end
  end
end
