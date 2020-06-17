defmodule PtChecker.Checker do
  alias PtChecker.Checks

  def check_route(dataset, relation_id) do
    ways_directions = PtChecker.Continuity.route_directions(dataset, relation_id)

    # TODO: check if it's a transport route and not random relation
    # TODO: check if it's not v1 route, don't bother validating v1,
    # don't bother validating garbage version

    context = %PtChecker.CheckContext{
      relation_id: relation_id,
      dataset: dataset,
      ways_directions: ways_directions
    }

    checks = [
      Checks.Informational
    ]

    errors =
      Enum.flat_map(checks, fn check_module ->
        apply(check_module, :check, [context])
      end)

    errors
  end
end
