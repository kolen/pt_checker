defmodule PtChecker.Checks.Members do
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

    {state, extras} =
      Enum.reduce(rel.members, {:stops, []}, fn {type, id, role}, {state, extras} ->
        case role do
          x
          when x in [
                 "stop",
                 "platform",
                 "stop_entry_only",
                 "stop_exit_only",
                 "platform_entry_only",
                 "platform_exit_only"
               ] ->
            case state do
              :stops -> {:stops, extras}
              :platforms -> {:bad, extras}
              :bad -> {:bad, extras}
            end

          "" ->
            case state do
              :stops -> {:platforms, extras}
              :platforms -> {:platforms, extras}
              :bad -> {:bad, extras}
            end

          _ ->
            {state, [{type, id} | extras]}
        end
      end)

    non_node_stops =
      rel.members
      |> Enum.filter(fn {type, _id, role} ->
        type != :node && role in ["stop", "stop_entry_only", "stop_exit_only"]
      end)
      |> Enum.map(fn {type, id, _role} -> {type, id} end)

    errors_if(context, [
      {{:members_wrong_order, :warning, []}, state == :bad},
      {{:members_extra, :error, extras}, extras != []},
      {{:members_non_node_stops, :error, non_node_stops}, non_node_stops != []}
    ])
  end
end
