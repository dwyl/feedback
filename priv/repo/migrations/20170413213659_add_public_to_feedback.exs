defmodule Feedback.Repo.Migrations.AddPublicToFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      add :public, :boolean
    end
  end
end
