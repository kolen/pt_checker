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
          x when x in ["stop", "platform"] ->
            case state do
              :stops -> {:stops, extras}
              :platforms -> {:bad, extras}
              :bad -> {:bad, extras}
            end

          "" ->
            case state do
              :stops -> {:platforms, extras}
              :platforms -> {:platforms, extras}
              :bad -> {:bad, [{type, id} | extras]}
            end

          _ ->
            {state, true}
        end
      end)

    non_node_stops =
      rel.members
      |> Enum.filter(fn {type, _id, role} ->
        type != :node && role == "stop"
      end)
      |> Enum.map(fn {type, id, _role} -> {type, id} end)

    errors_if(context, [
      {{:members_wrong_order, :error, []}, state == :bad},
      {{:members_extra, :error, extras}, extras != []},
      {{:members_non_node_stops, :error, non_node_stops}, non_node_stops != []}
    ])
  end
end
