defmodule OSMParsingTest do
  use ExUnit.Case, async: true
  doctest OSM.XML

  test "parses example from osm wiki" do
    example = """
    <?xml version="1.0" encoding="UTF-8"?>
    <osm version="0.6" generator="CGImap 0.0.2">
     <bounds minlat="54.0889580" minlon="12.2487570" maxlat="54.0913900" maxlon="12.2524800"/>
     <node id="298884269" lat="54.0901746" lon="12.2482632" user="SvenHRO" uid="46882" visible="true" version="1" changeset="676636" timestamp="2008-09-21T21:37:45Z"/>
     <node id="261728686" lat="54.0906309" lon="12.2441924" user="PikoWinter" uid="36744" visible="true" version="1" changeset="323878" timestamp="2008-05-03T13:39:23Z"/>
     <node id="1831881213" version="1" changeset="12370172" lat="54.0900666" lon="12.2539381" user="lafkor" uid="75625" visible="true" timestamp="2012-07-20T09:43:19Z">
      <tag k="name" v="Neu Broderstorf"/>
      <tag k="traffic_sign" v="city_limit"/>
     </node>
     ...
     <node id="298884272" lat="54.0901447" lon="12.2516513" user="SvenHRO" uid="46882" visible="true" version="1" changeset="676636" timestamp="2008-09-21T21:37:45Z"/>
     <way id="26659127" user="Masch" uid="55988" visible="true" version="5" changeset="4142606" timestamp="2010-03-16T11:47:08Z">
      <nd ref="292403538"/>
      <nd ref="298884289"/>
      ...
      <nd ref="261728686"/>
      <tag k="highway" v="unclassified"/>
      <tag k="name" v="Pastower Straße"/>
     </way>
     <relation id="56688" user="kmvar" uid="56190" visible="true" version="28" changeset="6947637" timestamp="2011-01-12T14:23:49Z">
      <member type="node" ref="294942404" role=""/>
      ...
      <member type="node" ref="364933006" role="Lol"/>
      <member type="way" ref="4579143" role=""/>
      ...
      <member type="node" ref="249673494" role=""/>
      <tag k="name" v="Küstenbus Linie 123"/>
      <tag k="network" v="VVW"/>
      <tag k="operator" v="Regionalverkehr Küste"/>
      <tag k="ref" v="123"/>
      <tag k="route" v="bus"/>
      <tag k="type" v="route"/>
     </relation>
     ...
    </osm>
    """

    {nodes, ways, relations} = OSM.XML.parse_string(example)

    assert length(Map.keys(nodes)) == 4

    assert nodes[1_831_881_213].tags == %{
             "name" => "Neu Broderstorf",
             "traffic_sign" => "city_limit"
           }

    assert nodes[1_831_881_213].lat == 54.0900666
    assert nodes[1_831_881_213].version_info.timestamp == ~U[2012-07-20T09:43:19Z]

    assert length(Map.keys(relations)) == 1

    assert relations[56688].version_info == %OSM.VersionInfo{
             changeset_id: 6_947_637,
             timestamp: ~U[2011-01-12 14:23:49Z],
             user: "kmvar",
             user_id: 56190,
             version: 28,
             visible: true
           }

    assert relations[56688].tags["operator"] == "Regionalverkehr Küste"

    assert relations[56688].members == [
             {:node, 294_942_404, ""},
             {:node, 364_933_006, "Lol"},
             {:way, 4_579_143, ""},
             {:node, 249_673_494, ""}
           ]

    assert ways[26_659_127] == %OSM.Way{
             id: 26_659_127,
             node_ids: [292_403_538, 298_884_289, 261_728_686],
             tags: %{"highway" => "unclassified", "name" => "Pastower Straße"},
             version_info: %OSM.VersionInfo{
               changeset_id: 4_142_606,
               timestamp: ~U[2010-03-16 11:47:08Z],
               user: "Masch",
               user_id: 55988,
               version: 5,
               visible: true
             }
           }
  end
end
