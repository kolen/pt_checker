defmodule PtChecker.Checker do
  alias PtChecker.Checks
  alias PtChecker.Result.RouteResult
  alias PtChecker.Result.GroupResult

  @doc """
  Checks root of route hierarchy: either route master or singular
  master-less route
  """
  @spec check_group_root(OSM.dataset(), integer()) :: PtChecker.Result.GroupResult.t()
  def check_group_root(dataset = {_, _, relations}, relation_id) do
    rel = relations[relation_id]

    case rel.tags["type"] do
      "route_master" ->
        check_group_route_master(dataset, relation_id)

      "route" ->
        check_group_bare(dataset, relation_id)

      _ ->
        %GroupResult{
          master_messages: [{:general_bad_master}]
        }
    end
  end

  defp check_group_route_master(dataset = {_, _, relations}, relation_id) do
    rel = relations[relation_id]

    {route_members, _other_members} =
      rel.members |> Enum.split_with(fn {type, _id, role} -> role == "" && type == :relation end)

    # TODO: report errors for `other_members`

    route_results =
      route_members
      |> Enum.map(fn {_type, id, _role} -> PtChecker.Checker.check_route(dataset, id) end)

    %GroupResult{
      relation_id: relation_id,
      master_tags: rel.tags,
      # TODO: detect and report errors
      master_messages: [],
      route_results: route_results
    }
  end

  defp check_group_bare(dataset, relation_id) do
    route_result = check_route(dataset, relation_id)

    %GroupResult{
      route_results: [route_result]
    }
  end

  @doc """
  Checks route relation
  """
  @spec check_route(OSM.dataset(), integer()) :: PtChecker.Result.RouteResult.t()
  def check_route(dataset, relation_id) do
    checks = [
      Checks.Main,
      Checks.Informational,
      Checks.Ways,
      Checks.Members
    ]

    {_, _, relations} = dataset
    relation = relations[relation_id]

    init_context = %PtChecker.CheckContext{dataset: dataset, relation_id: relation_id}

    {context, messages} =
      Enum.reduce_while(checks, {init_context, []}, fn check_module, {context, messages} ->
        {new_context, new_messages} = apply(check_module, :check, [context])

        {if(new_context.halt, do: :halt, else: :cont), {new_context, new_messages ++ messages}}
      end)

    %RouteResult{
      relation_id: relation_id,
      messages: messages |> Enum.reverse(),
      ways_directions: context.ways_directions,
      ways_coords: context.ways_coords,
      tags: relation.tags
    }
  end
end
