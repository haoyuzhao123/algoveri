import Mathlib

-- Precondition definitions

namespace InsertionSort

@[reducible, simp]
def insertionSort_precond (v : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definitions
def insertionSort (v : List Int) (h_precond : insertionSort_precond v) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def insertionSort_postcond (v : List Int) (result : List Int) (h_precond : insertionSort_precond v) : Prop :=
  -- !benchmark @start postcond
   List.Sorted (· ≤ ·) result ∧ result.Perm v
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem insertionSort_postcond_satisfied (v : List Int) (h_precond : insertionSort_precond v) :
    insertionSort_postcond v (insertionSort v h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end InsertionSort
  -- !benchmark @end proof
