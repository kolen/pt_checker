defmodule PtChecker.Route do
  use Ecto.Schema
  import Ecto.Changeset

  schema "routes" do
    field :ref, :string
    field :message_level, :string
    field :result, PtChecker.Result.Term
    timestamps()
  end

  @doc false
  def changeset(route, attrs) do
    route
    |> cast(attrs, [:ref, :message_level, :result])
    |> validate_required([])
  end
end
