defmodule PtChecker.Checker do
  alias PtChecker.Checks

  def check_route(dataset, relation_id) do
    # TODO: check if it's a transport route and not random relation
    # TODO: check if it's not v1 route, don't bother validating v1,
    # don't bother validating garbage version

    checks = [
      Checks.Informational,
      Checks.Ways
    ]

    init_context = %PtChecker.CheckContext{dataset: dataset, relation_id: relation_id}

    {context, errors} =
      Enum.reduce_while(checks, {init_context, []}, fn check_module, {context, errors} ->
        {new_context, new_errors} = apply(check_module, :check, [context])

        {if(new_context.halt, do: :halt, else: :cont), {new_context, new_errors ++ errors}}
      end)

    {context.ways_directions, Enum.reverse(errors)}
  end
end
