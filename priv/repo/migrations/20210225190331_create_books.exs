defmodule Examen.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :name, :string
      add :isbn, :string
      add :author_id, references(:authors, on_delete: :nothing)
      add :library_id, references(:libraries, on_delete: :nothing)

      timestamps()
    end

    create index(:books, [:author_id])
    create index(:books, [:library_id])
  end
end
