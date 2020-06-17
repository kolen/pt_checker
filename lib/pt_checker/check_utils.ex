defmodule PtChecker.CheckUtils do
  @spec errors_if([{error :: PtChecker.Check.message(), predicate :: boolean()}]) :: [
          PtChecker.Check.message()
        ]
  def errors_if(errors) do
    Enum.flat_map(errors, fn {error, predicate} ->
      if predicate, do: [error], else: []
    end)
  end
end
