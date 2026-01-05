import Mathlib

-- Precondition definitions

namespace MergeSort

@[reducible, simp]
def mergeSort_precond (v : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definitions
def mergeSort (v : List Int) (h_precond : mergeSort_precond v) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def mergeSort_postcond (v : List Int) (result : List Int) (h_precond : mergeSort_precond v) : Prop :=
  -- !benchmark @start postcond
   List.Sorted (· ≤ ·) result ∧ result.Perm v
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem mergeSort_postcond_satisfied (v : List Int) (h_precond : mergeSort_precond v) :
    mergeSort_postcond v (mergeSort v h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end MergeSort
  -- !benchmark @end proof
