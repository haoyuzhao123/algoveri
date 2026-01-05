import Mathlib

-- Precondition definitions

namespace BubbleSort

@[reducible, simp]
def bubble_sort_precond (v : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definitions
def bubble_sort (v : List Int) (h_precond : bubble_sort_precond v) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def bubble_sort_postcond (v : List Int) (result : List Int) (h_precond : bubble_sort_precond v) : Prop :=
  -- !benchmark @start postcond
  List.Sorted (· ≤ ·) result ∧ result.Perm v
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem bubble_sort_postcond_satisfied (v : List Int) (h_precond : bubble_sort_precond v) :
    bubble_sort_postcond v (bubble_sort v h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end BubbleSort
  -- !benchmark @end proof
