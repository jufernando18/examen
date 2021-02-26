defmodule Examen.HelperBooksTest do
  use Examen.DataCase
  use ExUnit.Case

  alias Examen.Repo
  alias Examen.HelperBooks
  alias Examen.HelperBooks.Book

  import Examen.Factory

  @valid_attrs %{isbn: "some isbn", name: "some name"}
  @update_attrs %{isbn: "some updated isbn", name: "some updated name"}
  @invalid_attrs %{isbn: nil, name: nil}

  describe "books" do
    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HelperBooks.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert HelperBooks.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert HelperBooks.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = HelperBooks.create_book(@valid_attrs)
      assert book.isbn == "some isbn"
      assert book.name == "some name"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HelperBooks.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, %Book{} = book} = HelperBooks.update_book(book, @update_attrs)
      assert book.isbn == "some updated isbn"
      assert book.name == "some updated name"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = HelperBooks.update_book(book, @invalid_attrs)
      assert book == HelperBooks.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = HelperBooks.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> HelperBooks.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = HelperBooks.change_book(book)
    end
  end

  describe "database_mock" do
    test "insert/1" do
      assert {:error, %Ecto.Changeset{errors: [name: {"can't be blank", [validation: :required]}] ,valid?: false}} = HelperBooks.create_book(%{@valid_attrs | name: nil})
      assert %Ecto.Changeset{valid?: true} = HelperBooks.change_book(%Book{}, @valid_attrs)
      {:ok, book} = HelperBooks.create_book(@valid_attrs)
      assert HelperBooks.get_book!(book.id) == book
    end

    test "insert/1 and update/2" do
      book = insert(:book, @valid_attrs)
      assert {:error, %Ecto.Changeset{errors: [name: {"can't be blank", [validation: :required]}] ,valid?: false}} = HelperBooks.update_book(book, %{@update_attrs | name: nil})
      assert_raise Ecto.NoPrimaryKeyValueError, fn -> HelperBooks.update_book( %{book | id: nil}, @update_attrs) end
      assert %Ecto.Changeset{changes: @update_attrs,valid?: true} = Book.changeset(book, @update_attrs)
      {:ok, _} =  HelperBooks.update_book(book, @update_attrs)
      %Ecto.Changeset{changes: changes,valid?: true} = Book.changeset(HelperBooks.get_book!(book.id), @update_attrs)
      assert map_size(changes) == 0
    end

    test "delete/1" do
      book = insert(:book, @valid_attrs)
      assert_raise Ecto.NoPrimaryKeyValueError, fn -> HelperBooks.delete_book(%{book | id: nil}) end
      assert {:ok, _} = HelperBooks.delete_book(book)
    end

    test "join" do
      author = insert(:author)
      library = insert(:library)
      params_with_assocs(:book, %{author: author, library: library}) |> HelperBooks.create_book
      insert_list(10, :book)

      query = from b in Book
      books = Repo.all(query)
      for book <- books, do: assert %Book{author: %Ecto.Association.NotLoaded{}, library: %Ecto.Association.NotLoaded{}} = book
      assert length(books) == 11

      query = from b in Book,
        join: l in assoc(b, :library),
        join: a in assoc(b, :author),
        select: b,
        preload: [library: l, author: a]
      books = Repo.all(query)
      for book <- books, do: assert %Book{author: %Examen.HelperAuthors.Author{}, library: %Examen.HelperLibraries.Library{}} = book
      assert length(books) == 11

      query = from b in Book,
        join: l in assoc(b, :library),
        join: a in assoc(b, :author),
        select: b,
        where: b.author_id == ^author.id and b.library_id == ^library.id,
        preload: [library: l, author: a]
      books = Repo.all(query)
      for book <- books, do: assert %Book{author: %Examen.HelperAuthors.Author{}, library: %Examen.HelperLibraries.Library{}} = book
      assert length(books) == 1
    end
  end
end
