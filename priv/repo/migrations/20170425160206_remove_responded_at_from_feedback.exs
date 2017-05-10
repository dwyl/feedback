defmodule Feedback.Repo.Migrations.RemoveRespondedAtFromFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      remove :responded_at
    end
  end
end
