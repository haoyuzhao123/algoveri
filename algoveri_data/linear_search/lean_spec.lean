import Mathlib

-- Precondition definitions

namespace LinearSearch

@[reducible, simp]
def linear_search_lower_bound_precond (seq : Array Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  seq.size ≤ 0x7FFFFFFF ∧
  (∀ (i j : Nat) (hi : i < j) (hj : j < seq.size), seq[i] ≤ seq[j])
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definitions
def linear_search_lower_bound (seq : Array Int) (target : Int) (h_precond : linear_search_lower_bound_precond seq target) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def linear_search_lower_bound_postcond (seq : Array Int) (target : Int) (result : Nat) (h_precond : linear_search_lower_bound_precond seq target) : Prop :=
  -- !benchmark @start postcond
  (∃ (h : result ≤ seq.size),
  (∀ (i : Nat) (hi : i < result), seq[i] < target) ∧
  (∀ (i : Nat) (hi : result ≤ i) (hj : i < seq.size), seq[i] ≥ target))
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem linear_search_lower_bound_postcond_satisfied (seq : Array Int) (target : Int) (h_precond : linear_search_lower_bound_precond seq target) :
    linear_search_lower_bound_postcond seq target (linear_search_lower_bound seq target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end LinearSearch
  -- !benchmark @end proof
