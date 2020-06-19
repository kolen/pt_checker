defmodule PtChecker.Checks.Main do
  import PtChecker.CheckUtils
  @behaviour PtChecker.Check

  @impl PtChecker.Check
  def check(
        context = %PtChecker.CheckContext{
          relation_id: relation_id,
          dataset: {_nodes, _ways, relations},
          ways_directions: _ways_directions
        }
      ) do
    rel = relations[relation_id]

    # If there's no `type=route`, don't bother analyzing it
    no_type_route = rel.tags["type"] != "route"
    # If version isn't 2 (by default treat it as 2), don't analyze it,
    # as we don't support other versions
    invalid_version = Map.get(rel.tags, "public_transport:version", "2") != "2"
    updated_context = %PtChecker.CheckContext{context | halt: no_type_route || invalid_version}

    errors_if(updated_context, [
      {{:main_invalid_type, :error, [{:relation, relation_id}]}, no_type_route},
      {{:main_invalid_version, :error, [:relation, relation_id]}, invalid_version}
    ])
  end
end
