defmodule Examen.HelperBooks.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :isbn, :string
    field :name, :string
    #field :author_id, :id
    #field :library_id, :id
    belongs_to :author, Examen.HelperAuthors.Author
    belongs_to :library, Examen.HelperLibraries.Library

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :isbn, :author_id, :library_id])
    |> validate_required([:name, :isbn])    #|> validate_required([:name, :isbn, :author_id])
    |> assoc_constraint(:author)
    |> assoc_constraint(:library)
  end
end
