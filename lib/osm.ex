defmodule OSM do
  @type dataset :: {
          %{optional(integer()) => OSM.Node.t()},
          %{optional(integer()) => OSM.Way.t()},
          %{optional(integer()) => OSM.Relation.t()}
        }

  @type ref :: {type :: :node | :way | :relation, id :: integer()}
end
