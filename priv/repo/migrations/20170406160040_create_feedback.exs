defmodule Feedback.Repo.Migrations.CreateFeedback do
  use Ecto.Migration

  def change do
    create table(:feedback) do
      add :item, :text
      add :response, :text
      add :responded, :boolean
      add :submitter_email, :string
      add :permalink_string, :string

      timestamps()
    end
  end
end
