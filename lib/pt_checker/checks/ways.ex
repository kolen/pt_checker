defmodule PtChecker.Checks.Ways do
  import PtChecker.CheckUtils
  @behaviour PtChecker.Check

  @impl PtChecker.Check
  def check(
        context = %PtChecker.CheckContext{
          relation_id: relation_id,
          dataset: dataset = {_nodes, ways, relations},
          ways_directions: nil
        }
      ) do
    _rel = relations[relation_id]

    ways_directions = PtChecker.Continuity.route_directions(dataset, relation_id)
    break_pairs = Enum.chunk_every(ways_directions, 2, 1, :discard)

    break_nodes =
      Enum.flat_map(break_pairs, fn [g1, g2] ->
        {way_id_1, dir1} = List.last(g1)
        {way_id_2, dir2} = List.first(g2)
        way1 = ways[way_id_1]
        way2 = ways[way_id_2]
        {_, break_node_1} = PtChecker.Continuity.first_last_nodes_by_direction(way1, dir1)
        {break_node_2, _} = PtChecker.Continuity.first_last_nodes_by_direction(way2, dir2)
        [{:node, break_node_1}, {:node, break_node_2}]
      end)

    updated_context = %PtChecker.CheckContext{context | ways_directions: ways_directions}

    errors_if(updated_context, [
      {{:ways_break, :error, break_nodes}, break_nodes != []},
      {{:ways_no_ways, :notice, [{:relation, relation_id}]}, ways_directions == []}
    ])
  end
end
