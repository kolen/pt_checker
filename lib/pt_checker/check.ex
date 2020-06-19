defmodule PtChecker.Check do
  @callback(
    check(PtChecker.CheckContext.t()) ::
      PtChecker.CheckContext.t(),
    [PtChecker.Result.message()]
  )
end
