defmodule Feedback.Response do
  use Feedback.Web, :model

  schema "response" do
    field :response, :string
    field :edit, :boolean
    field :edited, :boolean
    belongs_to :feedback, Feedback.Feedback

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:response, :edit, :edited, :feedback_id])
    |> validate_required([:response, :feedback_id])
    |> assoc_constraint(:feedback)
  end
end
