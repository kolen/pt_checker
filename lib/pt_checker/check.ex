defmodule PtChecker.Check do
  @type message ::
          {id :: String.t(), severity :: :notice | :warning | :error, references :: [OSM.ref()]}

  @callback check(PtChecker.CheckContext.t()) :: [message()]
end
