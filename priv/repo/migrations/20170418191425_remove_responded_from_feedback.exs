defmodule Feedback.Repo.Migrations.RemoveRespondedFromFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      remove :responded
    end
  end
end
