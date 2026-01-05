import Mathlib


namespace Knapsack01

def total_weight (selected : List Bool) (weights : List Nat) : Nat :=
  match selected, weights with
  | [], _ => 0
  | _, [] => 0
  | b :: bs, w :: ws => (if b then w else 0) + total_weight bs ws

def total_value (selected : List Bool) (values : List Nat) : Nat :=
  match selected, values with
  | [], _ => 0
  | _, [] => 0
  | b :: bs, v :: vs => (if b then v else 0) + total_value bs vs

def is_valid_strategy (selected : List Bool) (weights : List Nat) (capacity : Nat) : Prop :=
  selected.length = weights.length ∧
  total_weight selected weights ≤ capacity

-- Precondition definitions
@[reducible, simp]
def knapsack_01_precond (weights values : List Nat) (capacity : Nat) : Prop :=
  -- !benchmark @start precond
  weights.length = values.length ∧
  weights.length ≤ 100 ∧
  capacity ≤ 1000 ∧
  (∀ (i : Nat) (hi : i < weights.length), weights[i] ≤ 1000) ∧
  (∀ (i : Nat) (hi : i < values.length), values[i] ≤ 1000)
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def knapsack_01 (weights values : List Nat) (capacity : Nat)
    (h_precond : knapsack_01_precond weights values capacity) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def knapsack_01_postcond (weights values : List Nat) (capacity : Nat) (result : Nat)
    (_ : knapsack_01_precond weights values capacity) : Prop :=
  -- !benchmark @start postcond
  (∀ selected, is_valid_strategy selected weights capacity → total_value selected values ≤ result) ∧
  (∃ selected, is_valid_strategy selected weights capacity ∧ total_value selected values = result)
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem knapsack_01_postcond_satisfied (weights values : List Nat) (capacity : Nat)
    (h_precond : knapsack_01_precond weights values capacity) :
    knapsack_01_postcond weights values capacity (knapsack_01 weights values capacity h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end Knapsack01
  -- !benchmark @end proof
