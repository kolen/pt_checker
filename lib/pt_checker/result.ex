defmodule PtChecker.Result do
  @type message ::
          {id :: String.t(), severity :: :notice | :warning | :error, references :: [OSM.ref()]}
end
