defmodule PtChecker.Result.GroupResult do
  @moduledoc """
  Result for group of routes (route master and individual routes)
  """

  # master_messages may exist even if there's no master
  defstruct relation_id: nil,
            master_messages: [],
            master_tags: %{},
            route_results: []

  @type t :: %PtChecker.Result.GroupResult{
          relation_id: integer(),
          master_messages: [PtChecker.Result.message()],
          master_tags: %{optional(String.t()) => String.t()},
          route_results: [PtChecker.Result.RouteResult.t()]
        }
end
