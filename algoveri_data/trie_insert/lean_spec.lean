import Mathlib


namespace TrieInsert

inductive Node
| mk (is_end : Bool) (children : List (Option Node))
deriving Inhabited

namespace Node

def is_end (t : Node) : Bool :=
  match t with
  | Node.mk b _ => b

def children (t : Node) : List (Option Node) :=
  match t with
  | Node.mk _ c => c

end Node

-- Safe list access helper
def list_get_opt {α} (l : List α) (n : Nat) : Option α :=
  if h : n < l.length then some (l.get ⟨n, h⟩) else none

def contains (t : Node) (key : List Int) : Bool :=
  match key with
  | [] => t.is_end
  | c :: cs =>
    let children := t.children
      if c < children.length ∧ c ≥ 0 then
        match list_get_opt children c.toNat with
        | some (some child) => contains child cs
        | _ => false
      else
        false

-- View as a Set of key sequences (matching Verus/Dafny style)
def view (t : Node) : Set (List Int) :=
  {key | contains t key}

def is_empty_node (t : Node) : Bool :=
  !t.is_end ∧ t.children.all Option.isNone

def is_valid_key (key : List Int) : Prop :=
  ∀ k ∈ key, 0 ≤ k ∧ k < 256

-- Dafny uses an array of size 256. Here we model it as a list of 256 Option Node.
def well_formed (t : Node) : Prop :=
  match t with
  | Node.mk _ children =>
    children.length = 256 ∧
    ∀ c ∈ children, match c with
      | some child =>
          well_formed child ∧
          !is_empty_node child -- CRITICAL: Match Dafny's pruning invariant
      | none => True
termination_by sizeOf t
decreasing_by sorry

-- Precondition definitions
@[reducible, simp]
def insert_precond (t : Option Node) (key : List Int) : Prop :=
  -- !benchmark @start precond
  (match t with
  | some node => well_formed node ∧ !is_empty_node node
  | none => True) ∧
  is_valid_key key -- Added to match Dafny requirement
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def insert (t : Option Node) (key : List Int)
    (h_precond : insert_precond t key) : Node :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- View wrapper for Option Node
def view_opt (t : Option Node) : Set (List Int) :=
  match t with
  | some node => view node
  | none => ∅

-- Postcondition definitions
@[reducible, simp]
def insert_postcond (t : Option Node) (key : List Int) (result : Node)
    (_ : insert_precond t key) : Prop :=
  -- !benchmark @start postcond
  well_formed result ∧
  !is_empty_node result ∧
  view result = view_opt t ∪ {key}
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem insert_postcond_satisfied (t : Option Node) (key : List Int)
    (h_precond : insert_precond t key) :
    insert_postcond t key (insert t key h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end TrieInsert
  -- !benchmark @end proof
