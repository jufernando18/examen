defmodule Examen.HelperBooks.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :isbn, :string
    field :name, :string
    field :author_id, :id
    field :library_id, :id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :isbn])
    |> validate_required([:name, :isbn])
  end
end
