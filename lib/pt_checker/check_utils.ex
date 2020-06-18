defmodule PtChecker.CheckUtils do
  @spec errors_if(new_context :: PtChecker.CheckContext.t(), [
          {error :: PtChecker.Check.message(), predicate :: boolean()}
        ]) :: [
          PtChecker.Check.message()
        ]
  def errors_if(new_context, errors) do
    errors =
      Enum.flat_map(errors, fn {error, predicate} ->
        if predicate, do: [error], else: []
      end)

    {new_context, errors}
  end
end
