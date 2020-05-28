defmodule OSM.XML.Handler do
  @behaviour Saxy.Handler

  def handle_event(:start_document, _prolog, state) do
    {:ok, state}
  end

  def handle_event(:end_document, _data, {dataset, _cur_type, _cur_item}) do
    {:ok, {dataset, nil, nil}}
  end

  def handle_event(:start_element, {"node", attrs1}, {data, nil, nil}) do
    attrs = Enum.into(attrs1, %{})

    new_node = %OSM.Node{
      id: attrs["id"] |> String.to_integer(),
      lat: attrs["lat"] |> String.to_float(),
      lon: attrs["lon"] |> String.to_float(),
      version_info: version_info(attrs)
    }

    {:ok, {data, :node, new_node}}
  end

  def handle_event(:start_element, {"way", attrs1}, {data, nil, nil}) do
    attrs = Enum.into(attrs1, %{})

    new_way = %OSM.Way{
      id: attrs["id"] |> String.to_integer(),
      version_info: version_info(attrs)
    }

    {:ok, {data, :way, new_way}}
  end

  def handle_event(:start_element, {"relation", attrs1}, {data, nil, nil}) do
    attrs = Enum.into(attrs1, %{})

    new_relation = %OSM.Relation{
      id: attrs["id"] |> String.to_integer(),
      version_info: version_info(attrs)
    }

    {:ok, {data, :relation, new_relation}}
  end

  def handle_event(:start_element, {"tag", attrs1}, {data, cur_type, cur_item})
      when is_map(cur_item) do
    attrs = Enum.into(attrs1, %{})
    new_cur_item = Map.update!(cur_item, :tags, &Map.put(&1, attrs["k"], attrs["v"]))
    {:ok, {data, cur_type, new_cur_item}}
  end

  def handle_event(:start_element, {"nd", attrs1}, {data, :way, cur_way}) do
    attrs = Enum.into(attrs1, %{})
    node_id = attrs["ref"] |> String.to_integer()
    # Adding node id in reverse order
    new_cur_way = Map.update!(cur_way, :node_ids, &[node_id | &1])
    {:ok, {data, :way, new_cur_way}}
  end

  def handle_event(:start_element, {"member", attrs1}, {data, :relation, cur_relation}) do
    attrs = Enum.into(attrs1, %{})
    member_id = attrs["ref"] |> String.to_integer()

    member_type =
      case attrs["type"] do
        "node" -> :node
        "way" -> :way
        "relation" -> :relation
      end

    member_role = attrs["role"]
    # Adding node id in reverse order
    member = {member_type, member_id, member_role}
    new_cur_relation = Map.update!(cur_relation, :members, &[member | &1])
    {:ok, {data, :relation, new_cur_relation}}
  end

  # Catch-all for any other element to ignore it
  def handle_event(:start_element, {_name, _attributes}, state) do
    {:ok, state}
  end

  def handle_event(:end_element, "node", {{nodes, ways, relations}, :node, new_node}) do
    {:ok, {{Map.put(nodes, new_node.id, new_node), ways, relations}, nil, nil}}
  end

  def handle_event(:end_element, "way", {{nodes, ways, relations}, :way, new_way}) do
    # Node ids were originally in reversed order
    new_way_mod = Map.update!(new_way, :node_ids, &Enum.reverse/1)
    {:ok, {{nodes, Map.put(ways, new_way.id, new_way_mod), relations}, nil, nil}}
  end

  def handle_event(:end_element, "relation", {{nodes, ways, relations}, :relation, new_relation}) do
    # Relation members were originally in reversed order
    new_relation_mod = Map.update!(new_relation, :members, &Enum.reverse/1)
    {:ok, {{nodes, ways, Map.put(relations, new_relation.id, new_relation_mod)}, nil, nil}}
  end

  # Catch-all for any other element to ignore it
  def handle_event(:end_element, _name, state) do
    {:ok, state}
  end

  def handle_event(:characters, _chars, state) do
    # Chars aren't used in OSM format
    {:ok, state}
  end

  defp version_info(attrs) do
    {:ok, timestamp, 0} = DateTime.from_iso8601(attrs["timestamp"])

    visible =
      case attrs["visible"] do
        "true" -> true
        "false" -> false
        _ -> nil
      end

    %OSM.VersionInfo{
      changeset_id: attrs["changeset"] |> String.to_integer(),
      version: attrs["version"] |> String.to_integer(),
      timestamp: timestamp,
      visible: visible,
      user_id: attrs["uid"] |> String.to_integer(),
      user: attrs["user"]
    }
  end
end
