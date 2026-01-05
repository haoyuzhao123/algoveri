import Mathlib


namespace Lca

inductive Node where
  | nil
  | node (val : Nat) (left : Node) (right : Node)
deriving Inhabited, Repr

open Node

def view (t : Node) : Set Nat :=
  match t with
  | nil => ∅
  | node v l r => {v} ∪ view l ∪ view r

def tree_contains (t : Node) (target : Nat) : Bool :=
  match t with
  | nil => false
  | node v l r => v == target || tree_contains l target || tree_contains r target

def tree_distinct (t : Node) : Prop :=
  match t with
  | nil => True
  | node v l r =>
      tree_distinct l ∧ tree_distinct r ∧
      v ∉ view l ∧ v ∉ view r ∧
      (view l ∩ view r = ∅)

-- Precondition definitions
@[reducible, simp]
def lowest_common_ancestor_precond (root : Node) (p q : Nat) : Prop :=
  -- !benchmark @start precond
  tree_contains root p ∧ tree_contains root q ∧ tree_distinct root
  -- !benchmark @end precond

def aux (root : Node) (p q : Nat) : Option Nat × Bool × Bool :=
  match root with
  | nil => (none, false, false)
  | node val l r =>
      let (lcaL, hasPL, hasQL) := aux l p q
      let (lcaR, hasPR, hasQR) := aux r p q
      let hasP := (val == p) || hasPL || hasPR
      let hasQ := (val == q) || hasQL || hasQR
      let lca :=
        if lcaL.isSome then lcaL
        else if lcaR.isSome then lcaR
        else if hasP && hasQ then some val else none
      (lca, hasP, hasQ)

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def lowest_common_ancestor (root : Node) (p q : Nat)
    (h_precond : lowest_common_ancestor_precond root p q) : Option Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

def is_ancestor (root : Node) (anc target : Nat) : Prop :=
  match root with
  | nil => False
  | node v l r =>
      if v = anc then tree_contains (node v l r) target = true
      else is_ancestor l anc target ∨ is_ancestor r anc target

-- ADDED: Helper to determine depth for the "Lowest" check
def get_depth (root : Node) (target : Nat) : Option Nat :=
  match root with
  | nil => none
  | node v l r =>
      if v == target then some 0
      else
        match get_depth l target, get_depth r target with
        | some d, _ => some (d + 1)
        | none, some d => some (d + 1)
        | none, none => none

-- Postcondition definitions
@[reducible, simp]
def lowest_common_ancestor_postcond (root : Node) (p q : Nat) (result : Option Nat)
    (_ : lowest_common_ancestor_precond root p q) : Prop :=
  -- !benchmark @start postcond
  match result with
  | some lca =>
      -- 1. Validity: It is a common ancestor
      is_ancestor root lca p ∧
      is_ancestor root lca q ∧
      -- 2. Optimality: It is the LOWEST (Deepest) common ancestor
      (∀ x, is_ancestor root x p → is_ancestor root x q →
         match get_depth root x, get_depth root lca with
         | some dx, some dres => dx ≤ dres
         | _, _ => True) -- Should imply dx and dres exist if is_ancestor is true
  | none => False
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem lowest_common_ancestor_postcond_satisfied (root : Node) (p q : Nat)
    (h_precond : lowest_common_ancestor_precond root p q) :
    lowest_common_ancestor_postcond root p q (lowest_common_ancestor root p q h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end Lca
  -- !benchmark @end proof