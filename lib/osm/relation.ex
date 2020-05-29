defmodule OSM.Relation do
  defstruct id: nil, members: [], tags: %{}, version_info: nil

  @type t :: %OSM.Relation{
          id: integer(),
          members: [
            {
              type :: atom(),
              id :: integer(),
              role :: String.t()
            }
          ],
          tags: %{optional(String.t()) => String.t()},
          version_info: OSM.VersionInfo.t()
        }
end
