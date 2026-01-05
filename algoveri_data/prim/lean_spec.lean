import Mathlib

namespace prim

structure WeightedGraph where
  adj : Array (Array (Nat × Int))

def WeightedGraph.size (g : WeightedGraph) : Nat :=
  g.adj.size

def WeightedGraph.has_edge (g : WeightedGraph) (u v : Nat) (w : Int) : Prop :=
  u < g.size ∧
  ∃ pair, pair ∈ g.adj.getD u #[] ∧ pair.1 = v ∧ pair.2 = w

def WeightedGraph.well_formed (g : WeightedGraph) : Prop :=
  ∀ u, u < g.size →
    -- Bounds check
    (∀ pair, pair ∈ g.adj.getD u #[] → pair.1 < g.size) ∧
    -- Simple graph check (matches Dafny)
    (∀ p1 p2, p1 ∈ g.adj.getD u #[] → p2 ∈ g.adj.getD u #[] → p1.1 = p2.1 → p1 = p2)

structure MSTEdge where
  u : Nat
  v : Nat
  w : Int

-- 1. Validity
def MSTEdge.is_valid (e : MSTEdge) (g : WeightedGraph) : Prop :=
  g.has_edge e.u e.v e.w

-- 2. Connectivity for Solution Edges (Undirected View)
-- Dafny: `edge_in_set` checks (u, v) || (v, u)
def edges_contain (edges : List MSTEdge) (u v : Nat) : Prop :=
  ∃ e, e ∈ edges ∧ ((e.u = u ∧ e.v = v) ∨ (e.u = v ∧ e.v = u))

def path_follows_edges (edges : List MSTEdge) (p : List Nat) : Prop :=
  p.length > 0 ∧
  ∀ i, i + 1 < p.length →
    edges_contain edges (p.getD i 0) (p.getD (i + 1) 0)

def is_connected_with_edges (g : WeightedGraph) (edges : List MSTEdge) : Prop :=
  ∀ u v, u < g.size → v < g.size →
    ∃ p, p.head? = some u ∧ p.getLast? = some v ∧ path_follows_edges edges p

-- 3. Spanning Tree Definition
def is_spanning_tree (g : WeightedGraph) (edges : List MSTEdge) : Prop :=
  edges.length = g.size - 1 ∧
  (∀ e, e ∈ edges → e.is_valid g) ∧
  is_connected_with_edges g edges
  -- Note: |V|-1 edges + Connected implies Acyclic (Tree)

def total_weight (edges : List MSTEdge) : Int :=
  edges.foldl (λ sum e => sum + e.w) 0

-- 4. Optimality (MST)
def is_mst (g : WeightedGraph) (edges : List MSTEdge) : Prop :=
  is_spanning_tree g edges ∧
  ∀ other, is_spanning_tree g other → total_weight edges ≤ total_weight other

-- 5. Graph Connectivity (Precondition)
-- Dafny uses directed edges for the graph path check: `graph_has_any_edge`
def path_follows_graph (g : WeightedGraph) (p : List Nat) : Prop :=
  p.length > 0 ∧
  ∀ i, i + 1 < p.length →
    ∃ w, g.has_edge (p.getD i 0) (p.getD (i + 1) 0) w

def WeightedGraph.is_connected (g : WeightedGraph) : Prop :=
  ∀ u v, u < g.size → v < g.size →
    ∃ p, p.head? = some u ∧ p.getLast? = some v ∧ path_follows_graph g p

def WeightedGraph.weights_bounded (g : WeightedGraph) : Prop :=
  g.size ≤ 100000 ∧
  ∀ u v w, g.has_edge u v w → w ≥ -100000 ∧ w ≤ 100000

-- Precondition definitions
@[reducible, simp]
def prim_mst_precond (graph : WeightedGraph) : Prop :=
  -- !benchmark @start precond
  graph.well_formed ∧
  graph.size > 0 ∧
  graph.is_connected ∧
  graph.weights_bounded
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def prim_mst (graph : WeightedGraph)
    (h_precond : prim_mst_precond graph) : List MSTEdge :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def prim_mst_postcond (graph : WeightedGraph) (result : List MSTEdge)
    (_ : prim_mst_precond graph) : Prop :=
  -- !benchmark @start postcond
  is_mst graph result
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem prim_mst_postcond_satisfied (graph : WeightedGraph)
    (h_precond : prim_mst_precond graph) :
    prim_mst_postcond graph (prim_mst graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end prim
