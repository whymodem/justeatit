defmodule JustEatIt.Repo do
  use Ecto.Repo,
    otp_app: :just_eat_it,
    adapter: Ecto.Adapters.Postgres
end
