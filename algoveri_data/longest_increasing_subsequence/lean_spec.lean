import Mathlib

-- Precondition definitions

namespace LongestIncreasingSubsequence

@[reducible, simp]
def longest_increasing_subsequence_precond (seq : List Int) : Prop :=
  -- !benchmark @start precond
  seq.length ≤ 0x7FFFFFFFFFFFFFFF
  -- !benchmark @end precond


-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def longest_increasing_subsequence (seq : List Int)
    (h_precond : longest_increasing_subsequence_precond seq) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

/-
  Post‑condition auxiliary predicates.
-/

/-- `inc_nat l` states that the list `l` of natural numbers is strictly increasing. -/
def inc_nat (l : List Nat) : Prop :=
  ∀ (i j : Nat) (hi : i < j) (hj : i < l.length) (hj' : j < l.length), l[i] < l[j]

/-- `inc_vals seq indices` states that the values of `seq` at the given (strictly increasing)
    indices form a strictly increasing sequence. -/
def inc_vals (seq : List Int) (indices : List Nat) : Prop :=
  ∀ (i j : Nat) (hi : i < j) (hj : i < indices.length) (hj' : j < indices.length)
    (h_bound_i : indices[i] < seq.length) (h_bound_j : indices[j] < seq.length),
    seq[indices[i]]'(by exact h_bound_i) < seq[indices[j]]'(by exact h_bound_j)

/-- `is_valid_is seq indices` bundles the three necessary conditions for a list of indices
    to represent a valid increasing subsequence of `seq`. -/
def is_valid_is (seq : List Int) (indices : List Nat) : Prop :=
  inc_nat indices ∧
  (∀ i, i ∈ indices → i < seq.length) ∧
  inc_vals seq indices

-- Postcondition definitions
@[reducible, simp]
def longest_increasing_subsequence_postcond
    (seq : List Int) (result : Nat)
    (h_precond : longest_increasing_subsequence_precond seq) : Prop :=
  -- !benchmark @start postcond
  (∀ sub : List Nat, is_valid_is seq sub → sub.length > 0 → sub.length ≤ result) ∧
  (∃ sub : List Nat, is_valid_is seq sub ∧ sub.length = result)
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem longest_increasing_subsequence_postcond_satisfied
    (seq : List Int) (h_precond : longest_increasing_subsequence_precond seq) :
    longest_increasing_subsequence_postcond
      seq (longest_increasing_subsequence seq h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end LongestIncreasingSubsequence
  -- !benchmark @end proof
