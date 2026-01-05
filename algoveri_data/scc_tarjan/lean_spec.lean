import Mathlib

namespace scc_tarjan

structure SCCGraph where
  adj : Array (Array Nat)

def SCCGraph.well_formed (g : SCCGraph) : Prop :=
  ∀ u, u < g.adj.size →
    ∀ v, v ∈ g.adj.getD u #[] → v < g.adj.size

def SCCGraph.size (g : SCCGraph) : Nat :=
  g.adj.size

def SCCGraph.has_edge (g : SCCGraph) (u v : Nat) : Prop :=
  u < g.adj.size ∧
  v ∈ g.adj.getD u #[]

def SCCGraph.is_path (g : SCCGraph) (p : List Nat) : Prop :=
  p.length > 0 ∧
  ∀ i, i + 1 < p.length →
    g.has_edge (p.getD i 0) (p.getD (i + 1) 0)

def SCCGraph.has_path (g : SCCGraph) (u v : Nat) : Prop :=
  ∃ p, g.is_path p ∧ p.head? = some u ∧ p.getLast? = some v

def SCCGraph.is_strongly_connected (g : SCCGraph) (comp : List Nat) : Prop :=
  comp.length > 0 ∧
  (∀ u, u ∈ comp → u < g.size) ∧
  ∀ u v, u ∈ comp → v ∈ comp →
    (g.has_path u v ∧ g.has_path v u)

def SCCGraph.is_partition (g : SCCGraph) (sccs : List (List Nat)) : Prop :=
  -- Enforce no duplicate components to match index-based disjointness
  sccs.Nodup ∧
  -- All nodes covered
  (∀ u, u < g.size → ∃ comp, comp ∈ sccs ∧ u ∈ comp) ∧
  -- Disjoint
  (∀ c1 c2, c1 ∈ sccs → c2 ∈ sccs → c1 ≠ c2 →
    ∀ u, u ∈ c1 → u ∉ c2)

def SCCGraph.scc_has_path (g : SCCGraph) (c1 c2 : List Nat) : Prop :=
  ∃ u v, u ∈ c1 ∧ v ∈ c2 ∧ g.has_path u v

def SCCGraph.is_maximal_scc_structure (g : SCCGraph) (sccs : List (List Nat)) : Prop :=
  ∀ c1 c2, c1 ∈ sccs → c2 ∈ sccs → c1 ≠ c2 →
    (g.scc_has_path c1 c2 → ¬ g.scc_has_path c2 c1)

def SCCGraph.is_valid_scc_result (g : SCCGraph) (sccs : List (List Nat)) : Prop :=
  g.is_partition sccs ∧
  (∀ c, c ∈ sccs → g.is_strongly_connected c) ∧
  g.is_maximal_scc_structure sccs

-- Precondition definitions
@[reducible, simp]
def find_sccs_precond (graph : SCCGraph) : Prop :=
  -- !benchmark @start precond
  graph.well_formed ∧ graph.size ≤ 1000
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def find_sccs (graph : SCCGraph)
    (h_precond : find_sccs_precond graph) : List (List Nat) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def find_sccs_postcond (graph : SCCGraph) (result : List (List Nat))
    (_ : find_sccs_precond graph) : Prop :=
  -- !benchmark @start postcond
  graph.is_valid_scc_result result
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem find_sccs_postcond_satisfied (graph : SCCGraph)
    (h_precond : find_sccs_precond graph) :
    find_sccs_postcond graph (find_sccs graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end scc_tarjan
