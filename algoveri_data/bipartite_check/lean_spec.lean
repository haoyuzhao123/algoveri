namespace BipartiteCheck

structure BipartiteGraph where
  adj : Array (Array Nat)

def BipartiteGraph.well_formed (g : BipartiteGraph) : Prop :=
  ∀ (u : Nat) (hu : u < g.adj.size),
    ∀ v, v ∈ g.adj[u]'hu → v < g.adj.size

def BipartiteGraph.size (g : BipartiteGraph) : Nat :=
  g.adj.size

def BipartiteGraph.has_edge (g : BipartiteGraph) (u v : Nat) : Prop :=
  ∃ (hu : u < g.adj.size),
  v ∈ g.adj[u]'hu

def BipartiteGraph.is_valid_coloring (g : BipartiteGraph) (colors : Array Bool) : Prop :=
  colors.size = g.size ∧
  ∀ (u v : Nat) (hu : g.has_edge u v) (hcolors : u < colors.size) (hcolorsv : v < colors.size),
    colors[u]'(by grind) ≠ colors[v]'(by grind)

def BipartiteGraph.is_bipartite (g : BipartiteGraph) : Prop :=
  ∃ colors, g.is_valid_coloring colors

-- Precondition definitions
@[reducible, simp]
def check_bipartite_precond (graph : BipartiteGraph) : Prop :=
  -- !benchmark @start precond
  graph.well_formed
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def check_bipartite (graph : BipartiteGraph)
    (h_precond : check_bipartite_precond graph) : Option (Array Bool) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def check_bipartite_postcond (graph : BipartiteGraph) (result : Option (Array Bool))
    (_ : check_bipartite_precond graph) : Prop :=
  -- !benchmark @start postcond
  match result with
  | some colors => graph.is_valid_coloring colors
  | none => ¬ graph.is_bipartite
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem check_bipartite_postcond_satisfied (graph : BipartiteGraph)
    (h_precond : check_bipartite_precond graph) :
    check_bipartite_postcond graph (check_bipartite graph h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end BipartiteCheck
  -- !benchmark @end proof
