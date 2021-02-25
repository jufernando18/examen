defmodule Examen.Factory do
  use ExMachina.Ecto, repo: Examen.Repo

  use Examen.AuthorFactory
  use Examen.BooksFactory
  use Examen.LibrariesFactory
end
