defmodule PtChecker.Update do
  alias PtChecker.Route
  alias PtChecker.Repo

  def update(relation_id) do
    route = Repo.get! Route, relation_id
    dataset = PtChecker.Fetch.fetch(relation_id)
    result = PtChecker.Checker.check_group_root(dataset, relation_id)

    Route.changeset(route, %{result: result}) |> Repo.update!()
  end
end
