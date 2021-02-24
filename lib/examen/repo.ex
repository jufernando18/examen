defmodule Examen.Repo do
  use Ecto.Repo,
    otp_app: :examen,
    adapter: Ecto.Adapters.Postgres
end
