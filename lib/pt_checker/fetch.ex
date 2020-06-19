defmodule PtChecker.Fetch do
  def fetch(relation_id) do
    resp_body =
      PtChecker.OverpassAPI.query("""
      [timeout:5];
      (
        relation(#{relation_id});
      );
      (._; >>;);
      (._; >;);
      out body;
      """)

    OSM.XML.parse_string(resp_body)
  end
end
