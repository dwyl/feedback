defmodule Feedback.Repo.Migrations.RemovePrivateFromFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      remove :private
    end
  end
end
