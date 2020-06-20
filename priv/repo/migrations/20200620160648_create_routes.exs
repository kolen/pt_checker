defmodule PtChecker.Repo.Migrations.CreateRoutes do
  use Ecto.Migration

  def change do
    create table(:routes, primary_key: false) do
      add :id, :bigint, primary_key: true
      add :ref, :string
      add :message_level, :string
      add :result, :binary
      timestamps()
    end
  end
end
