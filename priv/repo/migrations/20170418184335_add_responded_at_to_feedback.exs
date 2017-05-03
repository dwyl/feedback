defmodule Feedback.Repo.Migrations.AddRespondedAtToFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      add :responded_at, :date
    end
  end
end
