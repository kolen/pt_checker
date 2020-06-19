defmodule PtChecker.Result.RouteResult do
  # TODO: stops
  defstruct relation_id: nil, messages: [], ways_directions: [], tags: %{}

  @type t :: %PtChecker.Result.RouteResult{
          relation_id: boolean(),
          messages: [PtChecker.Result.message()],
          ways_directions: [PtChecker.Continuity.ways_directions()],
          tags: %{optional(String.t()) => String.t()}
        }
end
