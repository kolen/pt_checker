defmodule OSM.Node do
  defstruct id: nil, lat: nil, lon: nil, tags: %{}, version_info: nil

  @type t :: %OSM.Node{
          id: integer(),
          lat: float(),
          lon: float(),
          tags: %{optional(String.t()) => String.t()},
          version_info: OSM.VersionInfo.t()
        }
end
