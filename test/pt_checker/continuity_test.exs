defmodule PtChecker.ContinuityTest do
  use ExUnit.Case, async: true
  alias PtChecker.Continuity, as: C
  doctest PtChecker.Continuity

  describe "direction_single" do
    test "treats loop way as forward" do
      assert C.direction_single(1, %OSM.Way{node_ids: [1, 2, 3, 1]}) == {:unknown_forward, 1}
    end

    test "detects unconnectable loop way" do
      assert C.direction_single(1, %OSM.Way{node_ids: [2, 3, 4, 2]}) == nil
    end

    test "determines direction of oneway loop way" do
      assert C.direction_single(1, %OSM.Way{
               node_ids: [1, 2, 3, 1],
               tags: %{"oneway" => "yes"}
             }) == {:forward, 1}

      assert C.direction_single(1, %OSM.Way{
               node_ids: [1, 2, 3, 1],
               tags: %{"oneway" => "reverse"}
             }) == {:backward, 1}
    end

    test "determines direction of oneway way" do
      assert C.direction_single(1, %OSM.Way{
               node_ids: [1, 2, 3],
               tags: %{"oneway" => "yes"}
             }) == {:forward, 3}

      assert C.direction_single(1, %OSM.Way{
               node_ids: [3, 2, 1],
               tags: %{"oneway" => "yes"}
             }) == nil
    end
  end

  describe "directions_group" do
    test "basic" do
      assert C.directions_group([
               %OSM.Way{id: 1, node_ids: [1, 2, 3]},
               %OSM.Way{id: 2, node_ids: [3, 2, 1]},
               %OSM.Way{id: 3, node_ids: [3, 2, 4]},
               %OSM.Way{id: 4, node_ids: [5, 6, 7]}
             ]) ==
               {[{1, :backward}, {2, :backward}, {3, :forward}],
                [%OSM.Way{id: 4, node_ids: [5, 6, 7]}]}
    end

    test "detects undecidable sequence" do
      assert C.directions_group([
               %OSM.Way{id: 1, node_ids: [1, 2, 3]},
               %OSM.Way{id: 2, node_ids: [3, 2, 1]},
               %OSM.Way{id: 3, node_ids: [1, 2, 3]}
             ]) == {[{1, :unknown_forward}, {2, :unknown_forward}, {3, :unknown_forward}], []}
    end

    test "returns empty directions for empty sequence" do
      assert C.directions_group([]) == {[], []}
    end

    test "works for single way" do
      assert C.directions_group([
               %OSM.Way{id: 1, node_ids: [1, 2, 3]}
             ]) == {[{1, :unknown_forward}], []}
    end
  end

  describe "directions" do
    test "basic" do
      assert C.directions([
               %OSM.Way{id: 1, node_ids: [1, 2, 3]},
               %OSM.Way{id: 2, node_ids: [3, 2, 1]},
               %OSM.Way{id: 3, node_ids: [3, 2, 4]},
               %OSM.Way{id: 4, node_ids: [5, 6, 7]}
             ]) == [[{1, :backward}, {2, :backward}, {3, :forward}], [{4, :unknown_forward}]]
    end

    test "basic 2" do
      #     (1)
      #   ,----,  (3)  (4)   (5)    (6)
      #  1      2----3--<--4-----5 6---7
      #   `----'
      #     (2)
      example_ways = [
        %OSM.Way{id: 1, node_ids: [1, 2]},
        %OSM.Way{id: 2, node_ids: [1, 2]},
        %OSM.Way{id: 3, node_ids: [2, 3]},
        %OSM.Way{id: 4, node_ids: [4, 3], tags: %{"oneway" => "yes"}},
        %OSM.Way{id: 5, node_ids: [5, 4]},
        %OSM.Way{id: 6, node_ids: [6, 7]}
      ]

      assert C.directions(example_ways) == [
               [{1, :backward}, {2, :forward}, {3, :forward}],
               [{4, :forward}],
               [{5, :unknown_forward}],
               [{6, :unknown_forward}]
             ]
    end
  end
end
