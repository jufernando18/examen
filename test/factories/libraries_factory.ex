defmodule Examen.LibrariesFactory do
  defmacro __using__(_opts) do
    quote do
      def library_factory do
        %Examen.HelperLibraries.Library{
          address: sequence(:address, &"CL-#{&1}#{&1+1}##{&1+5}C-#{&1+9}"),
          name: sequence(:name, &"random library ##{&1}#{&1+1}#{&1+5}#{&1+9}")
        }
      end
    end
  end
end
