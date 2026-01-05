import Mathlib

structure UnionFind where
  parent : List Nat
  rank   : List Nat
  len    : Nat
deriving Inhabited

namespace UnionFind

-- 1. Correct Invariant (Matches Dafny/Verus)
-- Must enforce rank monotonicity to prevent cycles.
def is_valid (uf : UnionFind) : Prop :=
  uf.parent.length = uf.len ∧
  uf.rank.length = uf.len ∧
  ∀ i, i < uf.len →
    let p := uf.parent.getD i 0
    p < uf.len ∧
    uf.rank.getD i 0 < uf.len ∧
    -- CRITICAL: Child rank must be strictly less than Parent rank (unless root)
    (p ≠ i → uf.rank.getD i 0 < uf.rank.getD p 0)

-- Measure for termination (Matches Dafny 'measure')
def measure (uf : UnionFind) (i : Nat) : Nat :=
  if h : i < uf.len then
    uf.len - uf.rank.getD i 0
  else 0

-- 2. Concrete Ghost Function (Matches Dafny 'spec_find')
-- We need this to define functional correctness.
def spec_find (uf : UnionFind) (i : Nat) : Nat :=
  if h : i < uf.len ∧ uf.rank.getD i 0 < uf.len then
    let p := uf.parent.getD i 0
    -- If valid parent exists with higher rank...
    if p ≠ i ∧ p < uf.len ∧ uf.rank.getD i 0 < uf.rank.getD p 0 then
      spec_find uf p
    else
      i
  else
    i
termination_by measure uf i
decreasing_by sorry

-- Precondition definitions
@[reducible, simp]
def link_roots_precond (uf : UnionFind) (root_i root_j : Nat) : Prop :=
  -- !benchmark @start precond
  uf.is_valid ∧
  root_i < uf.len ∧
  root_j < uf.len ∧
  uf.parent.getD root_i 0 = root_i ∧ -- Input i is a root
  uf.parent.getD root_j 0 = root_j    -- Input j is a root
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def link_roots (uf : UnionFind) (root_i root_j : Nat)
    (h_precond : link_roots_precond uf root_i root_j) : UnionFind :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def link_roots_postcond (uf : UnionFind) (root_i root_j : Nat) (result : UnionFind)
    (_ : link_roots_precond uf root_i root_j) : Prop :=
  -- !benchmark @start postcond
  result.is_valid ∧
  result.len = uf.len ∧
  -- Functional Correctness: The two trees are merged
  spec_find result root_i = spec_find result root_j ∧
  -- Frame Condition: Other roots must NOT change.
  -- (Matches Dafny: forall k ... old(parent)[k] == k ==> parent[k] == k)
  (∀ k, k < uf.len ∧ k ≠ root_i ∧ k ≠ root_j →
     uf.parent.getD k 0 = k → result.parent.getD k 0 = k)
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem link_roots_postcond_satisfied (uf : UnionFind) (root_i root_j : Nat)
    (h_precond : link_roots_precond uf root_i root_j) :
    link_roots_postcond uf root_i root_j (link_roots uf root_i root_j h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end UnionFind
