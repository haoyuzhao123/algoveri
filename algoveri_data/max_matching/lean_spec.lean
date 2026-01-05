import Mathlib


namespace MaxMatching

structure MaxMatchingGraph where
  left_size : Nat
  right_size : Nat
  adj : Array (Array Nat)

def MaxMatchingGraph.well_formed (g : MaxMatchingGraph) : Prop :=
  (∃ (h : g.adj.size = g.left_size),
  ∀ (u : Nat) (hu : u < g.left_size),
    ∀ v, v ∈ g.adj[u] → v < g.right_size)

def MaxMatchingGraph.has_edge (g : MaxMatchingGraph) (u v : Nat) : Prop :=
  (∃ (hu : u < g.left_size)
  (h_adj : g.adj.size = g.left_size),
  v ∈ g.adj[u])

-- Matching definition
structure Matching where
  edges : List (Nat × Nat)

def Matching.is_valid (m : Matching) (g : MaxMatchingGraph) : Prop :=
  ∀ e, e ∈ m.edges → g.has_edge e.1 e.2

def Matching.is_disjoint (m : Matching) : Prop :=
  ∀ e1 e2, e1 ∈ m.edges → e2 ∈ m.edges → e1 ≠ e2 →
    e1.1 ≠ e2.1 ∧ e1.2 ≠ e2.2

def Matching.size (m : Matching) : Nat :=
  m.edges.length

def is_matching (g : MaxMatchingGraph) (m : Matching) : Prop :=
  m.is_valid g ∧
  m.is_disjoint ∧
  m.edges.Nodup

def is_max_matching_size (g : MaxMatchingGraph) (k : Nat) : Prop :=
  (∃ m, is_matching g m ∧ m.size = k) ∧
  (∀ m, is_matching g m → m.size ≤ k)

-- Precondition definitions
@[reducible, simp]
def max_bipartite_matching_precond (graph : MaxMatchingGraph) : Prop :=
  -- !benchmark @start precond
  graph.well_formed ∧ graph.left_size ≤ 1000 ∧ graph.right_size ≤ 1000
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def max_bipartite_matching (graph : MaxMatchingGraph)
    (h_precond : max_bipartite_matching_precond graph) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def max_bipartite_matching_postcond (graph : MaxMatchingGraph) (result : Nat)
    (_ : max_bipartite_matching_precond graph) : Prop :=
  -- !benchmark @start postcond
  is_max_matching_size graph result
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem max_bipartite_matching_postcond_satisfied (graph : MaxMatchingGraph)
    (h_precond : max_bipartite_matching_precond graph) :
    max_bipartite_matching_postcond graph
      (max_bipartite_matching graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end MaxMatching
  -- !benchmark @end proof
