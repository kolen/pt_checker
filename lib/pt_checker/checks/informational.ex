defmodule PtChecker.Checks.Informational do
  import PtChecker.CheckUtils
  @behaviour PtChecker.Check

  @impl PtChecker.Check
  def check(%PtChecker.CheckContext{
        relation_id: relation_id,
        dataset: {_nodes, _ways, relations},
        ways_directions: _ways_directions
      }) do
    rel = relations[relation_id]

    errors_if([
      {{:info_no_ref_has_name, :notice, [{:relation, relation_id}]},
       Map.has_key?(rel.tags, "name") && not Map.has_key?(rel.tags, "ref")},
      {{:info_no_ref_no_name, :error, [{:relation, relation_id}]},
       not Map.has_key?(rel.tags, "name") && not Map.has_key?(rel.tags, "ref")},
      {{:info_no_version_2, :notice, [{:relation, relation_id}]},
       not Map.has_key?(rel.tags, "public_transport:version")},
      {{:info_version_old, :error, [{:relation, relation_id}]},
       rel.tags["public_transport:version"] == "1"},
      {{:info_no_operator, :notice, [{:relation, relation_id}]},
       not Map.has_key?(rel.tags, "operator")},
      {{:info_no_network, :notice, [{:relation, relation_id}]},
       not Map.has_key?(rel.tags, "network")},
      {{:info_no_from, :notice, [{:relation, relation_id}]}, not Map.has_key?(rel.tags, "from")},
      {{:info_no_to, :notice, [{:relation, relation_id}]}, not Map.has_key?(rel.tags, "to")}
    ])
  end
end
