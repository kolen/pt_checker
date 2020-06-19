[relation_id_s] = System.argv
relation_id = String.to_integer relation_id_s
dataset = PtChecker.Fetch.fetch relation_id
result = PtChecker.Checker.check_group_root(dataset, relation_id)
IO.inspect result
