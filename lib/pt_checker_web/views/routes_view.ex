defmodule PtCheckerWeb.RoutesView do
  use PtCheckerWeb, :view
  alias PtChecker.Result.GroupResult

  def route_ways_js(%GroupResult{route_results: route_results}) do
    data =
      route_results
      |> Enum.map(fn result ->
        result.ways_coords
        |> Enum.map(fn sequence ->
          sequence
          |> Enum.map(fn {lat, lon} ->
            [lat, lon]
          end)
        end)
      end)

    Poison.encode!(data)
  end
end
