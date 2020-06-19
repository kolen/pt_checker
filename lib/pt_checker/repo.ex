defmodule PtChecker.Repo do
  use Ecto.Repo,
    otp_app: :pt_checker,
    adapter: Ecto.Adapters.Postgres
end
