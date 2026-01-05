import Mathlib


namespace StackPush

structure VerifiableStack (T : Type) where
  data : List T

def VerifiableStack.view {T} (s : VerifiableStack T) : List T :=
  s.data

def VerifiableStack.is_valid {T} (s : VerifiableStack T) : Prop :=
  True

-- Precondition definitions
@[reducible, simp]
def push_precond {T} (s : VerifiableStack T) (v : T) : Prop :=
  -- !benchmark @start precond
  s.is_valid
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def push {T} (s : VerifiableStack T) (v : T)
    (h_precond : push_precond s v) : VerifiableStack T :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def push_postcond {T} (s : VerifiableStack T) (v : T) (result : VerifiableStack T)
    (_ : push_precond s v) : Prop :=
  -- !benchmark @start postcond
  result.is_valid ∧
  result.view = s.view ++ [v]
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem push_postcond_satisfied {T} (s : VerifiableStack T) (v : T)
    (h_precond : push_precond s v) :
    push_postcond s v (push s v h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end StackPush
  -- !benchmark @end proof
