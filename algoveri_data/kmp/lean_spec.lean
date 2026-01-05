import Mathlib

-- Precondition definitions

namespace Kmp

@[reducible, simp]
def kmpSearch_precond (haystack : Array UInt8) (needle : Array UInt8) : Prop :=
  -- !benchmark @start precond
  haystack.size < 1000000 ∧
  needle.size < 1000000
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def kmpSearch (haystack : Array UInt8) (needle : Array UInt8)
    (_ : kmpSearch_precond haystack needle) : Array Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition auxiliary definitions
def matchesAt (haystack needle : Array UInt8) (i : Nat) : Prop :=
  (∃ (h : i + needle.size ≤ haystack.size),
  (∀ (j : Nat) (hj : j < needle.size), haystack[i + j]'(by grind) = needle[j]))

-- Postcondition definitions
@[reducible, simp]
def kmpSearch_postcond (haystack : Array UInt8) (needle : Array UInt8)
    (result : Array Nat) (_ : kmpSearch_precond haystack needle) : Prop :=
  -- !benchmark @start postcond
  (∀ (i : Nat) (hi : i < result.size), matchesAt haystack needle (result[i])) ∧ -- Soundness
  (∀ i, matchesAt haystack needle i → ∃ (k : Nat) (hk : k < result.size), result[k] = i) -- Completeness
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem kmpSearch_postcond_satisfied (haystack : Array UInt8) (needle : Array UInt8)
    (h_precond : kmpSearch_precond haystack needle) :
    kmpSearch_postcond haystack needle (kmpSearch haystack needle h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end Kmp
  -- !benchmark @end proof
