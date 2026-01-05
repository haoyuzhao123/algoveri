import Mathlib

-- Precondition definitions

namespace QuickSort

@[reducible, simp]
def quickSort_precond (v : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definitions
def quickSort (v : List Int) (h_precond : quickSort_precond v) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def quickSort_postcond (v : List Int) (result : List Int) (h_precond : quickSort_precond v) : Prop :=
  -- !benchmark @start postcond
   List.Sorted (· ≤ ·) result ∧ result.Perm v
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem quickSort_postcond_satisfied (v : List Int) (h_precond : quickSort_precond v) :
    quickSort_postcond v (quickSort v h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end QuickSort
  -- !benchmark @end proof
