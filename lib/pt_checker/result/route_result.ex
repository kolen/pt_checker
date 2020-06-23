defmodule PtChecker.Result.RouteResult do
  # TODO: stops
  defstruct relation_id: nil, messages: [], ways_directions: [], ways_coords: nil, tags: %{}

  @type t :: %PtChecker.Result.RouteResult{
          relation_id: boolean(),
          messages: [PtChecker.Result.message()],
          ways_directions: [PtChecker.Continuity.ways_directions()],
          ways_coords: PtChecker.Continuity.ways_coords(),
          tags: %{optional(String.t()) => String.t()}
        }
end
