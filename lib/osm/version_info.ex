defmodule OSM.VersionInfo do
  defstruct changeset_id: nil, version: nil, timestamp: nil, visible: nil, user_id: nil, user: nil

  @type t :: %OSM.VersionInfo{
          changeset_id: integer(),
          version: integer(),
          timestamp: DateTime.t(),
          visible: boolean(),
          user_id: integer(),
          user: String.t()
        }
end
