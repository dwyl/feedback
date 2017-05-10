defmodule Feedback.Repo.Migrations.AddEditToFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      add :edit, :boolean
      add :edited, :boolean
    end
  end
end
