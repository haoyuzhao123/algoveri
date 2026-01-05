namespace KnapsackUnbounded

/-! ### Precondition definitions -/

def solve_knapsack_unbounded_precond (weights values : List Nat) (capacity : Nat) : Prop :=
  (weights.length = values.length) ∧
  (weights.length > 0) ∧
  (capacity ≤ 1000) ∧
  (∀ (i : Nat) (hi : i < weights.length), weights[i] > 0) ∧
  (∀ (i : Nat) (hi : i < weights.length), weights[i] ≤ 1000) ∧
  (∀ (i : Nat) (hi : i < values.length), values[i] ≤ 1000)

/-! ### Auxiliary definitions for the post‑condition -/

def list_nat_to_int (l : List Nat) : List Int :=
  l.map (fun x => Int.ofNat x)

def total_weight (counts weights : List Int) : Int :=
  (counts.zip weights).foldl (fun acc p => acc + p.1 * p.2) 0

def total_value (counts values : List Int) : Int :=
  (counts.zip values).foldl (fun acc p => acc + p.1 * p.2) 0

def is_valid_strategy (counts weights : List Int) (capacity : Int) : Prop :=
  counts.length = weights.length ∧
  (∀ (i : Nat) (h : i < counts.length), counts[i] ≥ 0) ∧
  total_weight counts weights ≤ capacity

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def solve_knapsack_unbounded
    (weights values : List Nat) (capacity : Nat)
    (h_precond : solve_knapsack_unbounded_precond weights values capacity) : Nat :=
  -- !benchmark @start code
  -- A placeholder implementation; the correctness proof is discharged by `sorry`.
  sorry
  -- !benchmark @end code

-- Postcondition definitions
def solve_knapsack_unbounded_postcond
    (weights values : List Nat) (capacity : Nat) (result : Nat)
    (h_precond : solve_knapsack_unbounded_precond weights values capacity) : Prop :=
  -- !benchmark @start postcond
  (∀ counts : List Int,
        is_valid_strategy counts (list_nat_to_int weights) (Int.ofNat capacity) →
        total_value counts (list_nat_to_int values) ≤ Int.ofNat result) ∧
  (∃ counts : List Int,
        is_valid_strategy counts (list_nat_to_int weights) (Int.ofNat capacity) ∧
        total_value counts (list_nat_to_int values) = Int.ofNat result)
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem solve_knapsack_unbounded_postcond_satisfied
    (weights values : List Nat) (capacity : Nat)
    (h_precond : solve_knapsack_unbounded_precond weights values capacity) :
    solve_knapsack_unbounded_postcond
      weights values capacity
      (solve_knapsack_unbounded weights values capacity h_precond)
      h_precond := by
  -- !benchmark @start proof
  sorry

end KnapsackUnbounded
  -- !benchmark @end proof
