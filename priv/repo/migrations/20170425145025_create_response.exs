defmodule Feedback.Repo.Migrations.CreateResponse do
  use Ecto.Migration

  def change do
    create table(:response) do
      add :response, :text
      add :edit, :boolean
      add :edited, :boolean
      add :feedback_id, references(:feedback, on_delete: :delete_all)

      timestamps()
    end

    create index(:response, [:feedback_id])
  end
end
