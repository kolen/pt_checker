defmodule OSM.XML do
  def parse_stream(stream) do
    {:ok, {data, nil, nil}} = Saxy.parse_stream(stream, OSM.XML.Handler, {{%{}, %{}, %{}}, nil, nil})
    data
  end

  def parse_string(string) do
    {:ok, {data, nil, nil}} = Saxy.parse_string(string, OSM.XML.Handler, {{%{}, %{}, %{}}, nil, nil})
    data
  end
end
