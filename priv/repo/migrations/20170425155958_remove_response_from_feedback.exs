defmodule Feedback.Repo.Migrations.RemoveResponseFromFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      remove :response
    end
  end
end
