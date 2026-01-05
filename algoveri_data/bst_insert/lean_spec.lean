import Mathlib


namespace BstInsert

inductive BinarySearchTree : Type
| Empty : BinarySearchTree
| Node : Int → BinarySearchTree → BinarySearchTree → BinarySearchTree

def view (t : BinarySearchTree) : Set Int :=
  match t with
  | BinarySearchTree.Empty => ∅
  | BinarySearchTree.Node v l r => view l ∪ view r ∪ {v}

def is_bst (t : BinarySearchTree) : Prop :=
  match t with
  | BinarySearchTree.Empty => True
  | BinarySearchTree.Node v l r =>
    (∀ x ∈ view l, x < v) ∧
    is_bst l ∧
    (∀ x ∈ view r, x > v) ∧
    is_bst r

-- Precondition definitions
@[reducible, simp]
def insert_precond (t : BinarySearchTree) (v : Int) : Prop :=
  -- !benchmark @start precond
  is_bst t
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def insert (t : BinarySearchTree) (v : Int)
    (h_precond : insert_precond t v) : BinarySearchTree :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition definitions
@[reducible, simp]
def insert_postcond (t : BinarySearchTree) (v : Int) (result : BinarySearchTree)
    (_ : insert_precond t v) : Prop :=
  -- !benchmark @start postcond
  is_bst result ∧
  view result = view t ∪ {v}
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem insert_postcond_satisfied (t : BinarySearchTree) (v : Int)
    (h_precond : insert_precond t v) :
    insert_postcond t v (insert t v h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end BstInsert
  -- !benchmark @end proof
