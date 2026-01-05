import Mathlib


namespace CycleDetection

structure CycleGraph where
  adj : Array (Array Nat)

def CycleGraph.well_formed (g : CycleGraph) : Prop :=
  ∀ (u : Nat) (hu : u < g.adj.size),
    ∀ v, v ∈ g.adj[u] → v < g.adj.size

def CycleGraph.size (g : CycleGraph) : Nat :=
  g.adj.size

def CycleGraph.has_edge (g : CycleGraph) (u v : Nat) : Prop :=
  ∃ (hu : u < g.adj.size), v ∈ g.adj[u]

def CycleGraph.is_path (g : CycleGraph) (p : List Nat) : Prop :=
  p.length > 0 ∧
  ∀ (i : Nat) (hi : i + 1 < p.length),
    g.has_edge (p[i]) (p[i + 1])

def CycleGraph.is_cycle (g : CycleGraph) (p : List Nat) : Prop :=
  g.is_path p ∧ p.length > 1 ∧ p.head? = p.getLast?

def CycleGraph.graph_has_cycle (g : CycleGraph) : Prop :=
  ∃ p, g.is_cycle p

-- Precondition definitions
@[reducible, simp]
def has_cycle_precond (graph : CycleGraph) : Prop :=
  -- !benchmark @start precond
  graph.well_formed
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def has_cycle (graph : CycleGraph)
    (h_precond : has_cycle_precond graph) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def has_cycle_postcond (graph : CycleGraph) (result : Bool)
    (_ : has_cycle_precond graph) : Prop :=
  -- !benchmark @start postcond
  result = graph.graph_has_cycle
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem has_cycle_postcond_satisfied (graph : CycleGraph)
    (h_precond : has_cycle_precond graph) :
    has_cycle_postcond graph (has_cycle graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end CycleDetection
  -- !benchmark @end proof
