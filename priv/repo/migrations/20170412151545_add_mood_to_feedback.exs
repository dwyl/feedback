defmodule Feedback.Repo.Migrations.AddMoodToFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      add :mood, :string
    end
  end
end
