defmodule Examen.BooksFactory do
  defmacro __using__(_opts) do
    quote do
      def book_factory do
        %Examen.HelperBooks.Book{
          isbn: sequence(:isbn, &"ISBN-#{&1}#{&1+1}#{&1+5}#{&1+9}"),
          name: sequence(:name, &"Some particular name - #{&1}"),
          author: build(:author),
          library: build(:library)
        }
      end
    end
  end
end
