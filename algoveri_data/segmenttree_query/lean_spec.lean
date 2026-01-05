import Mathlib


namespace SegmenttreeQuery

inductive Node
| mk (val : Int) (low high : Int) (left right : Option Node)
deriving Inhabited

namespace Node

def val (t : Node) : Int :=
  match t with | Node.mk v _ _ _ _ => v

def low (t : Node) : Int :=
  match t with | Node.mk _ l _ _ _ => l

def high (t : Node) : Int :=
  match t with | Node.mk _ _ h _ _ => h

def left (t : Node) : Option Node :=
  match t with | Node.mk _ _ _ l _ => l

def right (t : Node) : Option Node :=
  match t with | Node.mk _ _ _ _ r => r

end Node

def view (t : Node) : Int → Option Int :=
  fun k =>
    if k < t.low ∨ k ≥ t.high then none
    else
      match t.left, t.right with
      | some l, some r =>
          if k < l.high then view l k else view r k
      | _, _ => some t.val
termination_by sizeOf t
decreasing_by all_goals sorry

def is_segment_tree (t : Node) : Prop :=
  0 ≤ t.low ∧ t.low < t.high ∧ 0 ≤ t.val ∧
  match t.left, t.right with
  | some l, some r =>
      let mid := (t.low + t.high) / 2
      l.low = t.low ∧ l.high = mid ∧
      r.low = mid ∧ r.high = t.high ∧
      is_segment_tree l ∧ is_segment_tree r ∧
      t.val = max l.val r.val
  | none, none =>
      t.high = t.low + 1
  | _, _ => False
termination_by sizeOf t
decreasing_by all_goals sorry

-- Precondition definitions
@[reducible, simp]
def query_precond (node : Node) (ql qr : Int) : Prop :=
  -- !benchmark @start precond
  is_segment_tree node ∧
  ql < qr ∧
  node.low ≤ ql ∧
  qr ≤ node.high
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definition
def query (node : Node) (ql qr : Int)
    (h_precond : query_precond node ql qr) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Abstract View Helper used in Postcond
def tree_view_at (t : Node) (k : Int) : Int :=
  match view t k with
  | some v => v
  | none => 0

-- Postcondition definitions
@[reducible, simp]
def query_postcond (node : Node) (ql qr : Int) (result : Int)
    (_ : query_precond node ql qr) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  (∀ k, ql ≤ k ∧ k < qr → tree_view_at node k ≤ result) ∧
  (∃ k, ql ≤ k ∧ k < qr ∧ tree_view_at node k = result)
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem query_postcond_satisfied (node : Node) (ql qr : Int)
    (h_precond : query_precond node ql qr) :
    query_postcond node ql qr (query node ql qr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end SegmenttreeQuery
  -- !benchmark @end proof
