defmodule Examen.HelperAuthors.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :age, :integer
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    has_many :books, Examen.HelperBooks.Book

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:first_name, :last_name, :email, :age])
    |> validate_required([:first_name, :last_name, :email, :age])
  end
end
