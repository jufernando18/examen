defmodule Examen.HelperAuthorsTest do
  use Examen.DataCase
  use ExUnit.Case

  #alias Ecto.Changeset
  alias Examen.HelperAuthors
  alias Examen.HelperAuthors.Author

  import Examen.Factory

  @valid_attrs %{age: 42, email: "some email", first_name: "some first_name", last_name: "some last_name"}
  @update_attrs %{age: 43, email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name"}
  @invalid_attrs %{age: nil, email: nil, first_name: nil, last_name: nil}

  describe "authors" do
    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HelperAuthors.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert HelperAuthors.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert HelperAuthors.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = HelperAuthors.create_author(@valid_attrs)
      assert author.age == 42
      assert author.email == "some email"
      assert author.first_name == "some first_name"
      assert author.last_name == "some last_name"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HelperAuthors.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, %Author{} = author} = HelperAuthors.update_author(author, @update_attrs)
      assert author.age == 43
      assert author.email == "some updated email"
      assert author.first_name == "some updated first_name"
      assert author.last_name == "some updated last_name"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = HelperAuthors.update_author(author, @invalid_attrs)
      assert author == HelperAuthors.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = HelperAuthors.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> HelperAuthors.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = HelperAuthors.change_author(author)
    end
  end


  describe "database_mock" do
    test "insert/1" do
      assert {:error, %Ecto.Changeset{errors: [age: {"can't be blank", [validation: :required]}] ,valid?: false}} = HelperAuthors.create_author(%{@valid_attrs | age: nil})
      assert %Ecto.Changeset{valid?: true} = HelperAuthors.change_author(%Author{}, @valid_attrs)
      assert {:ok, author} = HelperAuthors.create_author(@valid_attrs)
      assert HelperAuthors.get_author!(author.id) == author
    end

    test "insert/1 and update/2" do
      author = insert(:author, @valid_attrs)
      assert {:error, %Ecto.Changeset{errors: [age: {"can't be blank", [validation: :required]}] ,valid?: false}} = HelperAuthors.update_author(author, %{@update_attrs | age: nil})
      assert_raise Ecto.NoPrimaryKeyValueError, fn -> HelperAuthors.update_author( %{author | id: nil}, @update_attrs) end
      assert %Ecto.Changeset{changes: @update_attrs,valid?: true} = Author.changeset(author, @update_attrs)
      {:ok, _} =  HelperAuthors.update_author(author, @update_attrs)
      %Ecto.Changeset{changes: changes,valid?: true} = Author.changeset(HelperAuthors.get_author!(author.id), @update_attrs)
      assert map_size(changes) == 0
    end

    test "delete/1" do
      author = insert(:author, @valid_attrs)
      assert_raise Ecto.NoPrimaryKeyValueError, fn -> HelperAuthors.delete_author(%{author | id: nil}) end
      assert {:ok, _} = HelperAuthors.delete_author(author)
    end
  end
end
