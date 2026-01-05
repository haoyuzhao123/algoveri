import Mathlib


namespace SplaytreeSplay

inductive SplayTree
| empty
| node (val : Int) (left right : SplayTree)
deriving Inhabited

namespace SplayTree

def view (t : SplayTree) : Set Int :=
  match t with
  | empty => ∅
  | node v l r => view l ∪ view r ∪ {v}
termination_by sizeOf t

def is_bst (t : SplayTree) : Prop :=
  match t with
  | empty => True
  | node v l r =>
    (∀ x ∈ view l, x < v) ∧
    is_bst l ∧
    (∀ x ∈ view r, x > v) ∧
    is_bst r
termination_by sizeOf t
decreasing_by all_goals sorry

def val (t : SplayTree) : Option Int :=
  match t with | node v _ _ => some v | empty => none

def is_node (t : SplayTree) : Bool :=
  match t with | node _ _ _ => true | empty => false

-- Precondition definitions
@[reducible, simp]
def splay_precond (t : SplayTree) (v : Int) : Prop :=
  -- !benchmark @start precond
  t.is_node ∧ is_bst t
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def splay (t : SplayTree) (v : Int)
    (h_precond : splay_precond t v) : SplayTree :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def splay_postcond (t : SplayTree) (v : Int) (result : SplayTree)
    (_ : splay_precond t v) : Prop :=
  -- !benchmark @start postcond
  result.is_node ∧
  is_bst result ∧
  view result = view t ∧
  (v ∈ view t → result.val = some v)
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem splay_postcond_satisfied (t : SplayTree) (v : Int)
    (h_precond : splay_precond t v) :
    splay_postcond t v (splay t v h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof

end SplayTree

end SplaytreeSplay
