import Mathlib

-- Precondition definitions

namespace KSmallest

@[reducible, simp]
def quick_select_precond (v : Array Int) (k : Nat) : Prop :=
  -- !benchmark @start precond
  k < v.size
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definitions
def quick_select (v : Array Int) (k : Nat) (h_precond : quick_select_precond v k) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def quick_select_postcond (v : Array Int) (k : Nat) (result : Int) (h_precond : quick_select_precond v k) : Prop :=
  -- !benchmark @start postcond
  ∃ (sorted : List Int) (hsorted : sorted.length = v.size),
    List.Sorted (· ≤ ·) sorted ∧
    sorted[k]'(by unfold quick_select_precond at h_precond; grind) = result ∧
    sorted.Perm v.toList
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem quick_select_postcond_satisfied (v : Array Int) (k : Nat) (h_precond : quick_select_precond v k) :
    quick_select_postcond v k (quick_select v k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end KSmallest
  -- !benchmark @end proof
