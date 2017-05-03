defmodule Feedback.Repo.Migrations.AddPrivacyToFeedback do
  use Ecto.Migration

  def change do
    alter table(:feedback) do
      add :private, :boolean
    end
  end
end
