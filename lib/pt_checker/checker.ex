defmodule PtChecker.Checker do
  alias PtChecker.Checks
  alias PtChecker.Result.RouteResult

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
      messages: messages |> Enum.reverse(),
      ways_directions: context.ways_directions,
      tags: relation.tags
    }
  end
end
