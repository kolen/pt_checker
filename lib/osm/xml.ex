defmodule OSM.XML do
  @doc """
  Parses OSM XML file into maps of nodes, ways and relations.
  """
  @spec parse_stream(any) :: OSM.dataset
  def parse_stream(stream) do
    {:ok, {data, nil, nil}} = Saxy.parse_stream(stream, OSM.XML.Handler, {{%{}, %{}, %{}}, nil, nil})
    data
  end

  @doc """
  Parses OSM XML file into maps of nodes, ways and relations.
  """
  @spec parse_string(String.t) :: OSM.dataset
  def parse_string(string) do
    {:ok, {data, nil, nil}} = Saxy.parse_string(string, OSM.XML.Handler, {{%{}, %{}, %{}}, nil, nil})
    data
  end
end
