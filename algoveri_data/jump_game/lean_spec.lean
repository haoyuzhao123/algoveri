import Mathlib

namespace jump_game

-- Precondition definition
@[reducible, simp]
def can_jump_precond (nums : List Nat) : Prop :=
  -- !benchmark @start precond
  0 < nums.length ∧
  nums.length ≤ 10000 ∧
  (∀ i, i < nums.length → nums.getD i 0 ≤ 10000)
  -- !benchmark @end precond

def is_valid_jump_path (path : List Nat) (nums : List Nat) : Prop :=
  path.length > 0 ∧
  path.head? = some 0 ∧
  path.getLast? = some (nums.length - 1) ∧
  (∀ i, i < path.length → path.getD i 0 < nums.length) ∧
  (∀ i, i < path.length - 1 →
    let u := path.getD i 0
    let v := path.getD (i+1) 0
    u < v ∧ v ≤ u + nums.getD u 0)

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def can_jump (nums : List Nat) (h_precond : can_jump_precond nums) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definition
@[reducible, simp]
def can_jump_postcond (nums : List Nat) (result : Bool) (h_precond : can_jump_precond nums) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ ∃ (path : List Nat), is_valid_jump_path path nums
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem can_jump_postcond_satisfied (nums : List Nat) (h_precond : can_jump_precond nums) :
    can_jump_postcond nums (can_jump nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end jump_game
