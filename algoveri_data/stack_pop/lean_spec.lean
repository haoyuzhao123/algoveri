import Mathlib


namespace StackPop

structure VerifiableStack (T : Type) where
  data : List T

def VerifiableStack.view {T} (s : VerifiableStack T) : List T :=
  s.data

def VerifiableStack.is_valid {T} (s : VerifiableStack T) : Prop :=
  True

-- Precondition definitions
@[reducible, simp]
def pop_precond {T} (s : VerifiableStack T) : Prop :=
  -- !benchmark @start precond
  s.is_valid ∧ s.view.length > 0
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
-- Returns the projected pair (val, new_stack)
def pop {T} (s : VerifiableStack T)
    (h_precond : pop_precond s) : T × VerifiableStack T :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def pop_postcond {T} (s : VerifiableStack T) (result : T × VerifiableStack T)
    (_ : pop_precond s) : Prop := -- We don't even need the proof term 'h' here!
  -- !benchmark @start postcond
  let (val, new_stack) := result
  new_stack.is_valid ∧
  -- Concise & Idiomatic: The old stack was the new stack followed by the popped value.
  s.view = new_stack.view ++ [val]
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem pop_postcond_satisfied {T} (s : VerifiableStack T)
    (h_precond : pop_precond s) :
    pop_postcond s (pop s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end StackPop
  -- !benchmark @end proof
