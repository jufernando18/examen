defmodule Examen.HelperBooksTest do
  use Examen.DataCase

  alias Examen.HelperBooks

  describe "books" do
    alias Examen.HelperBooks.Book

    @valid_attrs %{isbn: "some isbn", name: "some name"}
    @update_attrs %{isbn: "some updated isbn", name: "some updated name"}
    @invalid_attrs %{isbn: nil, name: nil}

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
end
