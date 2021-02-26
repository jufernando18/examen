defmodule Examen.HelperLibrariesTest do
  use Examen.DataCase
  use ExUnit.Case

  #alias Ecto.Changeset
  alias Examen.HelperLibraries
  alias Examen.HelperLibraries.Library

  import Examen.Factory

  describe "libraries" do
    alias Examen.HelperLibraries.Library

    @valid_attrs %{address: "some address", name: "some name"}
    @update_attrs %{address: "some updated address", name: "some updated name"}
    @invalid_attrs %{address: nil, name: nil}

    def library_fixture(attrs \\ %{}) do
      {:ok, library} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HelperLibraries.create_library()

      library
    end

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert HelperLibraries.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert HelperLibraries.get_library!(library.id) == library
    end

    test "create_library/1 with valid data creates a library" do
      assert {:ok, %Library{} = library} = HelperLibraries.create_library(@valid_attrs)
      assert library.address == "some address"
      assert library.name == "some name"
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HelperLibraries.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      assert {:ok, %Library{} = library} = HelperLibraries.update_library(library, @update_attrs)
      assert library.address == "some updated address"
      assert library.name == "some updated name"
    end

    test "update_library/2 with invalid data returns error changeset" do
      library = library_fixture()
      assert {:error, %Ecto.Changeset{}} = HelperLibraries.update_library(library, @invalid_attrs)
      assert library == HelperLibraries.get_library!(library.id)
    end

    test "delete_library/1 deletes the library" do
      library = library_fixture()
      assert {:ok, %Library{}} = HelperLibraries.delete_library(library)
      assert_raise Ecto.NoResultsError, fn -> HelperLibraries.get_library!(library.id) end
    end

    test "change_library/1 returns a library changeset" do
      library = library_fixture()
      assert %Ecto.Changeset{} = HelperLibraries.change_library(library)
    end
  end

  describe "database_mock" do
    test "insert/1" do
      assert {:error, %Ecto.Changeset{errors: [name: {"can't be blank", [validation: :required]}] ,valid?: false}} = HelperLibraries.create_library(%{@valid_attrs | name: nil})
      assert %Ecto.Changeset{valid?: true} = HelperLibraries.change_library(%Library{}, @valid_attrs)
      assert {:ok, library} = HelperLibraries.create_library(@valid_attrs)
      assert HelperLibraries.get_library!(library.id) == library
    end

    test "insert/1 and update/2" do
      library = insert(:library, @valid_attrs)
      assert {:error, %Ecto.Changeset{errors: [name: {"can't be blank", [validation: :required]}] ,valid?: false}} = HelperLibraries.update_library(library, %{@update_attrs | name: nil})
      assert_raise Ecto.NoPrimaryKeyValueError, fn -> HelperLibraries.update_library( %{library | id: nil}, @update_attrs) end
      assert %Ecto.Changeset{changes: @update_attrs,valid?: true} = Library.changeset(library, @update_attrs)
      {:ok, _} =  HelperLibraries.update_library(library, @update_attrs)
      %Ecto.Changeset{changes: changes,valid?: true} = Library.changeset(HelperLibraries.get_library!(library.id), @update_attrs)
      assert map_size(changes) == 0
    end

    test "delete/1" do
      library = insert(:library, @valid_attrs)
      assert_raise Ecto.NoPrimaryKeyValueError, fn -> HelperLibraries.delete_library(%{library | id: nil}) end
      assert {:ok, _} = HelperLibraries.delete_library(library)
    end
  end
end
