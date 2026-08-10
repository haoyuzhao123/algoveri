import unittest

from src.eval.semantic_eval import SemanticEval, partition_submission_by_ownership


LEAN_SUBMISSION = """import Mathlib

def teacher_helper (n : Nat) : Nat :=
  teacher_helper n
termination_by n
decreasing_by sorry

-- !benchmark @start auxcode
def model_helper : Nat := 1
-- !benchmark @end auxcode

def answer : Nat :=
  -- !benchmark @start code
  model_helper
  -- !benchmark @end code

-- !benchmark @start lemma
theorem model_helper_eq : model_helper = 1 := by rfl
-- !benchmark @end lemma

theorem answer_eq : answer = 1 := by
  -- !benchmark @start proof
  exact model_helper_eq
  -- !benchmark @end proof
"""


class MockSemanticChat:
    def __init__(self):
        self.history = []
        self.total_tokens = {"input": 0, "output": 0}

    def send_message(self, text, role="user", temperature=1.0):
        self.history.append({"role": role, "content": text})
        student_content = text.split("Student-Authored Content:\n", 1)[1]
        student_content = student_content.split("\n\nHard requirements:", 1)[0]

        if "sorry" in student_content:
            analysis = (
                "The trusted teacher scaffold is not used as evidence of cheating. "
                "The student-authored content contains `sorry`, so the submission cheats."
            )
            conclusion = "NO"
        else:
            analysis = (
                "The teacher-owned termination proof contains `sorry`, but the labeled "
                "student-authored sections do not. The submitted implementation and proof "
                "match the requested behavior."
            )
            conclusion = "YES"

        response = f"<analysis>{analysis}</analysis>\n<conclusion>{conclusion}</conclusion>"
        self.history.append({"role": "assistant", "content": response})
        self.total_tokens["input"] += len(text.split())
        self.total_tokens["output"] += len(response.split())
        return {"text": response, "role": "assistant", "raw": {"mock": True}}

    def get_history(self):
        return [message.copy() for message in self.history]

    def get_total_tokens(self):
        return self.total_tokens.copy()


class MockSemanticProvider:
    def __init__(self):
        self.chat = None

    def new_chat(self, model="", system_prompt=None, **kwargs):
        self.chat = MockSemanticChat()
        return self.chat


class SemanticOwnershipTest(unittest.TestCase):
    def test_partitions_marked_lean_submission(self):
        submission = partition_submission_by_ownership(LEAN_SUBMISSION)

        self.assertIn("decreasing_by sorry", submission["teacher_scaffold"])
        self.assertNotIn("def model_helper : Nat := 1", submission["teacher_scaffold"])
        self.assertIn("def model_helper : Nat := 1", submission["student_sections"])
        self.assertNotIn("decreasing_by sorry", submission["student_sections"])
        for name in ("auxcode", "code", "lemma", "proof"):
            self.assertIn(
                f"--- BEGIN MODEL-AUTHORED SECTION: {name} ---",
                submission["student_sections"],
            )

    def test_unmarked_submission_is_fully_student_owned(self):
        code = "def answer : Nat := 1"
        submission = partition_submission_by_ownership(code)

        self.assertEqual(submission["student_sections"], code)
        self.assertIn("No trusted ownership boundaries", submission["ownership_instructions"])

    def test_semantic_prompt_labels_teacher_and_student_content(self):
        evaluator = SemanticEval(llm_client=None)
        prompt = evaluator.make_initial_prompt("Return one.", LEAN_SUBMISSION)

        self.assertIn("Teacher-Provided Scaffold:", prompt)
        self.assertIn("Student-Authored Content:", prompt)
        self.assertIn("trusted `sorry` declarations", prompt)
        self.assertIn("decreasing_by sorry", prompt)

    def test_mock_api_accepts_teacher_owned_sorry(self):
        provider = MockSemanticProvider()
        evaluator = SemanticEval(llm_client=provider, max_rounds=1)

        result = evaluator.run_single(
            natural_language="Return one.",
            formal_code=LEAN_SUBMISSION,
            model="mock-semantic-judge",
            filename="mock",
        )

        self.assertTrue(result["parsed"])
        self.assertTrue(result["verdict"])
        self.assertIn("teacher-owned termination proof", result["analysis"])
        self.assertEqual(provider.chat.history[-1]["role"], "assistant")

    def test_mock_api_rejects_student_owned_sorry(self):
        provider = MockSemanticProvider()
        evaluator = SemanticEval(llm_client=provider, max_rounds=1)
        cheating_submission = LEAN_SUBMISSION.replace(
            "exact model_helper_eq",
            "sorry",
        )

        result = evaluator.run_single(
            natural_language="Return one.",
            formal_code=cheating_submission,
            model="mock-semantic-judge",
            filename="mock",
        )

        self.assertTrue(result["parsed"])
        self.assertFalse(result["verdict"])
        self.assertIn("student-authored content contains `sorry`", result["analysis"])


if __name__ == "__main__":
    unittest.main()
