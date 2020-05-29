defmodule OSM.Way do
  defstruct id: nil, node_ids: [], tags: %{}, version_info: nil

  @type t :: %OSM.Way{
          id: integer(),
          node_ids: [integer()],
          tags: %{optional(String.t()) => String.t()},
          version_info: OSM.VersionInfo.t()
        }
end
