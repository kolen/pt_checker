defmodule PtChecker.CheckContext do
  defstruct relation_id: nil, dataset: {%{}, %{}, %{}}, ways_directions: nil, halt: false

  @type t :: %PtChecker.CheckContext{
          relation_id: integer(),
          dataset: OSM.dataset(),
          ways_directions: PtChecker.Continuity.ways_directions()
        }
end
