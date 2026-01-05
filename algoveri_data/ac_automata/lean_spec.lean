-- Precondition definitions

namespace AcAutomata

@[reducible, simp]
def ac_automata_search_precond (haystack : Array UInt8) (patterns : Array (Array UInt8)) : Prop :=
  -- !benchmark @start precond
  haystack.size < 10^6 ∧
  patterns.size > 0 ∧
  patterns.size < 10^6 ∧
  (∀ i : Nat, (h : i < patterns.size) →
    let p := patterns[i]
    p.size < 10^6)
  -- !benchmark @end precond

-- !benchmark @start auxcode
-- !benchmark @end auxcode

-- Main function definitions
def ac_automata_search (haystack : Array UInt8) (patterns : Array (Array UInt8))
    (_ : ac_automata_search_precond haystack patterns) :
    Array (Nat × Nat) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- Postcondition auxiliary definitions
def is_matches_at (haystack needle : Array UInt8) (start : Nat) : Prop :=
  ∃ (h : start + needle.size ≤ haystack.size),
    ∀ (i : Nat) (hi : i < needle.size),
      haystack[start + i]'(by grind) = needle[i]'hi

-- Postcondition definitions
@[reducible, simp]
def ac_automata_search_postcond (haystack : Array UInt8) (patterns : Array (Array UInt8))
    (result : Array (Nat × Nat)) (_ : ac_automata_search_precond haystack patterns) : Prop :=
  -- !benchmark @start postcond
  (∀ (i : Nat) (hi : i < result.size),
      let pair := result[i]
      let pid := pair.fst
      let idx := pair.snd
      ∃ (h : pid < patterns.size),
      is_matches_at haystack (patterns[pid]'h) idx) ∧
  (∀ (pid idx : Nat) (hpid : pid < patterns.size),
      is_matches_at haystack (patterns[pid]'hpid) idx →
      ∃ (k : Nat) (hk : k < result.size), result[k] = (pid, idx))
  -- !benchmark @end postcond

-- !benchmark @start lemma
-- !benchmark @end lemma

-- Proof content
theorem ac_automata_search_postcond_satisfied (haystack : Array UInt8) (patterns : Array (Array UInt8))
    (h_precond : ac_automata_search_precond haystack patterns) :
    ac_automata_search_postcond haystack patterns
      (ac_automata_search haystack patterns h_precond) h_precond := by
  -- !benchmark @start proof
  sorry

end AcAutomata
  -- !benchmark @end proof
