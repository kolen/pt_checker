defmodule PtChecker.Messages do
  import PtCheckerWeb.Gettext

  def message_title(id) do
    # TODO: return also message description
    case id do
      :main_invalid_type ->
        dgettext "messages", "Invalid relation type"
      :main_invalid_version ->
        dgettext "messages", "Invalid route version"
      :info_no_ref_has_name ->
        dgettext "messages", "Missing 'ref' tag"
      :info_no_ref_no_name ->
        dgettext "messages", "Missing 'ref' and 'name' tags"
      :info_no_version_2 ->
        dgettext "messages", "Missing public_transport:version tag"
      :info_no_operator ->
        dgettext "messages", "Missing 'operator' tag"
      :info_no_network ->
        dgettext "messages", "Missing 'network' tag"
      :info_no_from ->
        dgettext "messages", "Missing 'from' tag"
      :info_no_to ->
        dgettext "messages", "Missing 'to' tag"
      :members_wrong_order ->
        dgettext "messages", "Wrong order of relation members"
      :members_extra ->
        dgettext "messages", "Unknown extra relation members"
      :members_non_node_stops ->
        dgettext "messages", "Relation contain stops that aren't nodes"
      :ways_break ->
        dgettext "messages", "Breaks in continuity of ways"
      :ways_no_ways ->
        dgettext "messages", "Route contains no ways"
    end
  end
end
