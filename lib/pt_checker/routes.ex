defmodule PtChecker.Routes do
  alias PtChecker.Route
  alias PtChecker.Repo
  import Ecto.Query, only: [from: 2]

  @doc """
  Updates route (group) data from remote server and stores its
  validation result
  """
  def update(relation_id) do
    route = Repo.get! Route, relation_id
    dataset = PtChecker.Fetch.fetch(relation_id)
    result = PtChecker.Checker.check_group_root(dataset, relation_id)

    Route.changeset(route, %{result: result}) |> Repo.update!()
  end

  def summary() do
    query = from r in "routes", select: %{id: r.id, ref: r.ref}
    Repo.all(query)
  end
end
