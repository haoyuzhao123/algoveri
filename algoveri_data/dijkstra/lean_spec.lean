

namespace Dijkstra

structure WeightedGraph where
  adj : Array (Array (Nat × Int))

def WeightedGraph.size (g : WeightedGraph) : Nat :=
  g.adj.size

def WeightedGraph.has_edge (g : WeightedGraph) (u v : Nat) (w : Int) : Prop :=
  ∃ (hu : u < g.size),
  ∃ pair, pair ∈ g.adj[u] ∧ pair.1 = v ∧ pair.2 = w

def WeightedGraph.well_formed (g : WeightedGraph) : Prop :=
  ∀ (u : Nat) (hu : u < g.size),
    -- All targets in range
    (∀ pair, pair ∈ g.adj[u] → pair.1 < g.size) ∧
    -- Unique targets (simple graph)
    (∀ p1 p2, p1 ∈ g.adj[u] → p2 ∈ g.adj[u] → p1.1 = p2.1 → p1 = p2)

def WeightedGraph.get_edge_weight (g : WeightedGraph) (_ _ : Nat) : Int :=
  -- Since edges are unique, we can abstractly pick the weight
  -- In specification logic, we can use `Classical.choose` or similar if needed.
  -- But since we pass adjacency list, we can just say "w s.t. has_edge"
  -- For simple functional definition:
  0 -- placeholder for helper, spec logic mainly uses has_edge

def WeightedGraph.is_path (g : WeightedGraph) (p : List Nat) : Prop :=
  p.length > 0 ∧
  ∀ (i : Nat) (hi : i + 1 < p.length),
    ∃ w, g.has_edge (p[i]) (p[i + 1]) w

def WeightedGraph.path_weight (_ : WeightedGraph) (p : List Nat) : Int :=
  match p with
  | [] => 0
  | [_] => 0
  | _ :: _ :: _ =>
      -- This assumes unique edges logic or we need an explicit path including weights
      -- For simplicity, we assume `has_edge` defines the unique weight
      -- and we sum it up. However, extracting it in logic is annoying.
      -- Let's define path_weight relationally instead.
      0

def WeightedGraph.path_has_weight (g : WeightedGraph) (p : List Nat) (w_total : Int) : Prop :=
  match p with
  | [] => w_total = 0
  | [_] => w_total = 0
  | u :: v :: rest =>
      ∃ w_edge w_rest,
        g.has_edge u v w_edge ∧
        g.path_has_weight (v :: rest) w_rest ∧
        w_total = w_edge + w_rest

def WeightedGraph.is_shortest_dist (g : WeightedGraph) (start target : Nat) (d : Int) : Prop :=
  (∃ p, g.is_path p ∧ p.head? = some start ∧ p.getLast? = some target ∧ g.path_has_weight p d) ∧
  (∀ p w, g.is_path p → p.head? = some start → p.getLast? = some target → g.path_has_weight p w → w >= d)

def WeightedGraph.weights_non_negative (g : WeightedGraph) : Prop :=
  ∀ u v w, g.has_edge u v w → w >= 0

def WeightedGraph.weights_and_size_bounded (g : WeightedGraph) : Prop :=
  g.size ≤ 100000 ∧
  ∀ u v w, g.has_edge u v w → w ≥ -100000 ∧ w ≤ 100000

-- Precondition definitions
@[reducible, simp]
def dijkstra_shortest_paths_precond (graph : WeightedGraph) (start : Nat) : Prop :=
  -- !benchmark @start precond
  graph.well_formed ∧
  start < graph.size ∧
  graph.weights_non_negative ∧
  graph.weights_and_size_bounded
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def dijkstra_shortest_paths (graph : WeightedGraph) (start : Nat)
    (h_precond : dijkstra_shortest_paths_precond graph start) : List (Option Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def dijkstra_shortest_paths_postcond (graph : WeightedGraph) (start : Nat)
    (result : List (Option Int))
    (_ : dijkstra_shortest_paths_precond graph start) : Prop :=
  -- !benchmark @start postcond
  ∃ (h : result.length = graph.size),
  ∀ (v : Nat) (hv : v < graph.size),
    match result[v]'(by grind) with
    | some d => graph.is_shortest_dist start v d
    | none => ¬ ∃ p, graph.is_path p ∧ p.head? = some start ∧ p.getLast? = some v
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem dijkstra_shortest_paths_postcond_satisfied (graph : WeightedGraph) (start : Nat)
    (h_precond : dijkstra_shortest_paths_precond graph start) :
    dijkstra_shortest_paths_postcond graph start
      (dijkstra_shortest_paths graph start h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end Dijkstra
  -- !benchmark @end proof
