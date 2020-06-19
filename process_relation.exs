[relation_id_s] = System.argv
relation_id = String.to_integer relation_id_s

data = PtChecker.Fetch.fetch relation_id

{_, _, relations} = data
rel = relations[relation_id]

%{tags: %{"type" => "route_master"}} = rel

result = Enum.map(rel.members, fn {type, id, role} ->
  case type do
    :relation ->
      {id, PtChecker.Checker.check_route(data, id)}
    _ -> {id, {type, role}}
  end
end)

IO.inspect result
