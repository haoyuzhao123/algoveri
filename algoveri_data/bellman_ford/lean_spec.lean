namespace BellmanFord

structure WeightedGraph where
  adj : Array (Array (Nat × Int))

def WeightedGraph.size (g : WeightedGraph) : Nat :=
  g.adj.size

def WeightedGraph.has_edge (g : WeightedGraph) (u v : Nat) (w : Int) : Prop :=
  ∃ (h : u < g.size) (pair : (Nat × Int)), pair ∈ g.adj[u]'h ∧ pair.1 = v ∧ pair.2 = w

def WeightedGraph.well_formed (g : WeightedGraph) : Prop :=
  ∀ (u : Nat) (hu : u < g.size),
    -- All targets in range
    (∀ (pair : (Nat × Int)), pair ∈ g.adj[u]'hu → pair.1 < g.size) ∧
    -- Unique targets (simple graph)
    (∀ (p1 p2 : (Nat × Int)), p1 ∈ g.adj[u]'hu → p2 ∈ g.adj[u]'hu → p1.1 = p2.1 → p1 = p2)

def WeightedGraph.path_has_weight (g : WeightedGraph) (p : List Nat) (w_total : Int) : Prop :=
  match p with
  | [] => w_total = 0
  | [_] => w_total = 0
  | u :: v :: rest =>
      ∃ w_edge w_rest,
        g.has_edge u v w_edge ∧
        g.path_has_weight (v :: rest) w_rest ∧
        w_total = w_edge + w_rest

def WeightedGraph.is_path (g : WeightedGraph) (p : List Nat) : Prop :=
  p.length > 0 ∧
  match p with
  | [] => True
  | [_] => True
  | u :: v :: rest =>
      (∃ w, g.has_edge u v w) ∧ g.is_path (v :: rest)

-- Shortest path predicate
def WeightedGraph.is_shortest_dist (g : WeightedGraph) (start target : Nat) (d : Int) : Prop :=
  (∃ p, g.is_path p ∧ p.head? = some start ∧ p.getLast? = some target ∧ g.path_has_weight p d) ∧
  (∀ p w, g.is_path p → p.head? = some start → p.getLast? = some target → g.path_has_weight p w → w >= d)

-- Negative cycle predicate
def WeightedGraph.has_negative_cycle (g : WeightedGraph) : Prop :=
  ∃ p w, g.is_path p ∧ p.length > 1 ∧ p.head? = p.getLast? ∧ g.path_has_weight p w ∧ w < 0

def WeightedGraph.weights_and_size_bounded (g : WeightedGraph) : Prop :=
  g.size ≤ 100000 ∧
  ∀ u v w, g.has_edge u v w → w ≥ -100000 ∧ w ≤ 100000

-- Precondition definitions
@[reducible, simp]
def bellman_ford_precond (graph : WeightedGraph) (start : Nat) : Prop :=
  -- !benchmark @start precond
  graph.well_formed ∧
  start < graph.size ∧
  graph.weights_and_size_bounded
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def bellman_ford (graph : WeightedGraph) (start : Nat)
    (h_precond : bellman_ford_precond graph start) : Option (List (Option Int)) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def bellman_ford_postcond (graph : WeightedGraph) (start : Nat)
    (result : Option (List (Option Int)))
    (_ : bellman_ford_precond graph start) : Prop :=
  -- !benchmark @start postcond
  match result with
  | some dists =>
      (∃ (h : dists.length = graph.size),
      ∀ (v : Nat) (hv : v < graph.size),
        match dists[v]'(by grind) with
        | some d => graph.is_shortest_dist start v d
        | none => ¬ ∃ p, graph.is_path p ∧ p.head? = some start ∧ p.getLast? = some v)
  | none =>
      graph.has_negative_cycle
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem bellman_ford_postcond_satisfied (graph : WeightedGraph) (start : Nat)
    (h_precond : bellman_ford_precond graph start) :
    bellman_ford_postcond graph start
      (bellman_ford graph start h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end BellmanFord
  -- !benchmark @end proof
