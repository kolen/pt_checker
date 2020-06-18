defmodule PtChecker.Checks.Ways do
  import PtChecker.CheckUtils
  @behaviour PtChecker.Check

  @impl PtChecker.Check
  def check(
        context = %PtChecker.CheckContext{
          relation_id: relation_id,
          dataset: dataset = {_nodes, _ways, relations},
          ways_directions: nil
        }
      ) do
    _rel = relations[relation_id]

    ways_directions = PtChecker.Continuity.route_directions(dataset, relation_id)

    # TODO: find end nodes before break and start nodes after break
    # and output in context

    # TODO: check presence of ways, add notice if not present

    updated_context = %PtChecker.CheckContext{context | ways_directions: ways_directions}

    errors_if(updated_context, [])
  end
end
