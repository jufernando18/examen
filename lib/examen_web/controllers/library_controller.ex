defmodule ExamenWeb.LibraryController do
  use ExamenWeb, :controller

  alias Examen.HelperLibraries
  alias Examen.HelperLibraries.Library

  def index(conn, _params) do
    libraries = HelperLibraries.list_libraries()
    render(conn, "index.html", libraries: libraries)
  end

  def new(conn, _params) do
    changeset = HelperLibraries.change_library(%Library{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"library" => library_params}) do
    case HelperLibraries.create_library(library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library created successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    library = HelperLibraries.get_library!(id)
    render(conn, "show.html", library: library)
  end

  def edit(conn, %{"id" => id}) do
    library = HelperLibraries.get_library!(id)
    changeset = HelperLibraries.change_library(library)
    render(conn, "edit.html", library: library, changeset: changeset)
  end

  def update(conn, %{"id" => id, "library" => library_params}) do
    library = HelperLibraries.get_library!(id)

    case HelperLibraries.update_library(library, library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library updated successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", library: library, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    library = HelperLibraries.get_library!(id)
    {:ok, _library} = HelperLibraries.delete_library(library)

    conn
    |> put_flash(:info, "Library deleted successfully.")
    |> redirect(to: Routes.library_path(conn, :index))
  end
end
