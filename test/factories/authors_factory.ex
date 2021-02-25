defmodule Examen.AuthorFactory do
  defmacro __using__(_opts) do
    quote do
      def author_factory do
        %Examen.HelperAuthors.Author{
          age: 43,
          email: sequence(:email, &"author-#{&1}@author.com.co"),
          first_name: "some name",
          last_name: "some last"
        }
      end
    end
  end
end
