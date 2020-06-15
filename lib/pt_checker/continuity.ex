defmodule PtChecker.Continuity do
  @doc """
  Returns direction of single way when using starting_node

  Returns direction of single way when using starting_node along with
  node id that will become new starting node, or nil if it can't be
  connected to starting node.

  # Examples

      iex> PtChecker.Continuity.direction_single 1, %OSM.Way{node_ids: [1,2,3,4]}
      {:forward, 4}

      iex> PtChecker.Continuity.direction_single 1, %OSM.Way{node_ids: [4,2,3,1]}
      {:backward, 4}

      iex> PtChecker.Continuity.direction_single 1, %OSM.Way{node_ids: [2,3,4]}
      nil

      iex> PtChecker.Continuity.direction_single 1, %OSM.Way{node_ids: [1,2,3,1]}
      {:unknown_forward, 1}
  """
  def direction_single(starting_node, way) do
    {first, last} = first_last_nodes(way)
    ow = oneway(way)

    cond do
      is_nil(ow) && first == last && first == starting_node ->
        {:unknown_forward, last}

      first == starting_node && ow != :reverse_oneway ->
        {:forward, last}

      last == starting_node && ow != :oneway ->
        {:backward, first}

      true ->
        nil
    end
  end

  @doc """
  Returns directions of sequence of ways

  Returns directions of ways' sequence starting at `starting_node`,
  along with way ids, and remaining unconnected ways.

  # Examples

      iex> PtChecker.Continuity.directions_from_starting_node 1, [
      ...>   %OSM.Way{id: 1, node_ids: [3, 2, 1]},
      ...>   %OSM.Way{id: 2, node_ids: [3, 4]},
      ...>   %OSM.Way{id: 3, node_ids: [5, 6, 7]}
      ...> ]
      {[{1, :backward}, {2, :forward}],
       [%OSM.Way{id: 3, node_ids: [5, 6, 7], tags: %{}, version_info: nil}]}
  """
  def directions_from_starting_node(starting_node, ways) do
    {dirs, rem} = directions_from_starting_node_(starting_node, ways, [])
    {Enum.reverse(dirs), rem}
  end

  defp directions_from_starting_node_(_starting_node, [], directions) do
    {directions, []}
  end

  defp directions_from_starting_node_(starting_node, ways, directions) do
    [way | next_ways] = ways

    case direction_single(starting_node, way) do
      nil ->
        {directions, ways}

      {dir, next_starting_node} ->
        directions_from_starting_node_(next_starting_node, next_ways, [{way.id, dir} | directions])
    end
  end

  @doc """
  Returns directions until break and remaining ways

  # Examples

      iex> PtChecker.Continuity.directions_group [
      ...>   %OSM.Way{id: 1, node_ids: [1,2,3]},
      ...>   %OSM.Way{id: 2, node_ids: [5,4,3]},
      ...>   %OSM.Way{id: 3, node_ids: [6,7]}
      ...> ]
      {[{1, :forward}, {2, :backward}],
       [%OSM.Way{id: 3, node_ids: [6, 7], tags: %{}, version_info: nil}]}

  """
  def directions_group(ways)

  def directions_group([]) do
    {[], []}
  end

  def directions_group(ways) do
    variants =
      possible_starting_nodes(hd(ways))
      |> Enum.map(fn starting_node ->
        directions_from_starting_node(starting_node, ways)
      end)

    case variants do
      [variant] ->
        variant

      [{dirs1, rem1}, {dirs2, _rem2}] when length(dirs1) == length(dirs2) ->
        {Enum.map(dirs1, fn dir ->
           case dir do
             {id, :forward} -> {id, :unknown_forward}
             {id, :backward} -> {id, :unknown_backward}
           end
         end), rem1}

      vs ->
        Enum.max_by(vs, &length(elem(&1, 0)))
    end
  end

  @doc """
  Returns groups of connected components of ways with their directions.

  # Examples

  iex> PtChecker.Continuity.directions [
  ...>   %OSM.Way{id: 1, node_ids: [1, 2, 3]},
  ...>   %OSM.Way{id: 2, node_ids: [3, 2, 1]},
  ...>   %OSM.Way{id: 3, node_ids: [3, 2, 4]},
  ...>   %OSM.Way{id: 4, node_ids: [5, 6, 7]},
  ...>   %OSM.Way{id: 5, node_ids: [5, 7, 8]}
  ...> ]
  [[{1, :backward}, {2, :backward}, {3, :forward}], [{4, :backward}, {5, :forward}]]
  """
  def directions(ways) do
    Enum.reverse(directions_(ways, []))
  end

  defp directions_([], groups) do
    groups
  end

  defp directions_(ways, groups) do
    {group, rem} = directions_group(ways)
    directions_(rem, [group | groups])
  end

  defp route_ways({_nodes, ways, relations}, relation_id) do
    relations[relation_id].members
    |> Enum.filter(fn {type, _id, role} -> role == "" && type == :way end)
    |> Enum.map(fn {_, id, _} -> ways[id] end)
  end

  @doc """
  Returns directions along with way ids for route's ways
  """
  def route_directions({nodes, ways, relations}, relation_id) do
    ways = route_ways({nodes, ways, relations}, relation_id)
    directions(ways)
  end

  # Returns nodes that could be starting for way condsidered in isolation
  defp possible_starting_nodes(way) do
    {first, last} = first_last_nodes(way)

    case oneway(way) do
      :oneway -> [first]
      :reverse_oneway -> [last]
      nil -> [first, last]
    end
  end

  @doc """
  Determines oneway status of a way: `:oneway`, `:reverse_oneway` or
  `:bad` (when `oneway` key has unknown value).

  # Examples

      iex> PtChecker.Continuity.oneway %OSM.Way{tags: %{"oneway" => "1"}}
      :oneway
      iex> PtChecker.Continuity.oneway %OSM.Way{tags: %{"oneway" => "reverse"}}
      :reverse_oneway
      iex> PtChecker.Continuity.oneway %OSM.Way{tags: %{"oneway" => "foo"}}
      nil
      iex> PtChecker.Continuity.oneway %OSM.Way{tags: %{"oneway" => "foo"}}, true
      :bad
  """
  def oneway(way, check_bad \\ false)

  def oneway(%OSM.Way{tags: %{"oneway" => oneway}}, check_bad) do
    case oneway do
      "yes" -> :oneway
      "1" -> :oneway
      "true" -> :oneway
      "-1" -> :reverse_oneway
      "reverse" -> :reverse_oneway
      _ -> if check_bad, do: :bad, else: nil
    end
  end

  def oneway(_way, _check_bad) do
    nil
  end

  defp first_last_nodes(%{node_ids: node_ids}) do
    {hd(node_ids), List.last(node_ids)}
  end
end
