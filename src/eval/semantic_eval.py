from __future__ import annotations
from abc import ABC, abstractmethod
from typing import Any, Dict, Optional
import re
from .prompt.semantic_check_prompt import SEMANTIC_SYS_PROMPT, SEMANTIC_INITIAL_PROMPT, SEMANTIC_REVISION_PROMPT

LEAN_MODEL_SECTIONS = ("auxcode", "code", "lemma", "proof")
LEAN_SECTION_PATTERN = re.compile(
    r"-- !benchmark @start (?P<name>auxcode|code|lemma|proof)"
    r"(?P<body>.*?)"
    r"-- !benchmark @end (?P=name)",
    re.DOTALL,
)


def partition_submission_by_ownership(formal_code: str) -> Dict[str, str]:
    """Separate a marked Lean submission into teacher and model-owned content."""
    matches = list(LEAN_SECTION_PATTERN.finditer(formal_code))
    names = [match.group("name") for match in matches]

    if len(matches) != len(LEAN_MODEL_SECTIONS) or set(names) != set(LEAN_MODEL_SECTIONS):
        return {
            "ownership_instructions": (
                "No trusted ownership boundaries were detected. Treat the entire submitted "
                "answer as student-authored when checking for cheating."
            ),
            "teacher_scaffold": "(No separately identified teacher scaffold.)",
            "student_sections": formal_code,
        }

    def scaffold_placeholder(match: re.Match[str]) -> str:
        name = match.group("name")
        return (
            f"-- !benchmark @start {name}\n"
            f"-- MODEL-AUTHORED SECTION: {name}\n"
            f"-- !benchmark @end {name}"
        )

    teacher_scaffold = LEAN_SECTION_PATTERN.sub(scaffold_placeholder, formal_code)
    sections = []
    for name in LEAN_MODEL_SECTIONS:
        match = next(item for item in matches if item.group("name") == name)
        sections.append(
            f"--- BEGIN MODEL-AUTHORED SECTION: {name} ---"
            f"{match.group('body')}"
            f"--- END MODEL-AUTHORED SECTION: {name} ---"
        )

    return {
        "ownership_instructions": (
            "The teacher scaffold is fixed benchmark content. Only the four explicitly "
            "labeled model-authored sections were supplied by the student. When checking "
            "for cheating, inspect only those model-authored sections. In particular, "
            "trusted `sorry` declarations in the teacher scaffold, typically in "
            "`decreasing_by` termination proofs, must not affect the verdict."
        ),
        "teacher_scaffold": teacher_scaffold,
        "student_sections": "\n\n".join(sections),
    }


class SemanticEval:
    """Abstract evaluator: drives multi-turn LLM interaction and verification.

    Subclasses must implement prompt generation and response handling for specific
    languages (Dafny, Lean, Rust).
    """

    def __init__(self, llm_client, max_rounds: int = 5):
        # llm_client is a provider
        self.llm_client = llm_client
        self.max_rounds = max_rounds
    
    def make_sys_prompt(self) -> str:
        return SEMANTIC_SYS_PROMPT

    def make_initial_prompt(self, natural_language, formal_code) -> str:
        submission = partition_submission_by_ownership(formal_code)
        return SEMANTIC_INITIAL_PROMPT.format(
            description=natural_language,
            ownership_instructions=submission["ownership_instructions"],
            teacher_scaffold=submission["teacher_scaffold"],
            student_sections=submission["student_sections"],
        )
    
    def make_revision_prompt(self) -> str:
        return SEMANTIC_REVISION_PROMPT

    def parse_llm_response(self, response: str, formal_code: str = None) -> Dict[str, str]:
        """Parse LLM response to extract analysis and conclusion."""
        analysis_match = re.search(r"<analysis>(.*?)</analysis>", response, re.DOTALL)
        conclusion_match = re.search(r"<conclusion>(.*?)</conclusion>", response, re.DOTALL)

        analysis = analysis_match.group(1).strip() if analysis_match else ""
        conclusion = conclusion_match.group(1).strip().upper() if conclusion_match else ""

        verdict = None
        if conclusion == "YES":
            verdict = True
        elif conclusion == "NO":
            verdict = False

        parsed = ( (verdict is not None) and (analysis != "") )

        return {
            "parsed": parsed,
            "verdict": verdict,
            "analysis": analysis,
        }

    def run_single(self, natural_language: str, formal_code: str, model: str, filename: str, spec: str = "", system_prompt: str = "", debug: bool=False) -> Dict[str, str]:
        """Run a single problem through multi-turn loop until verified or exhausted using model."""
        sys_prompt = self.make_sys_prompt()
        # initial user prompt
        prompt = self.make_initial_prompt(natural_language, formal_code)

        if debug:
            print(f"Creating chat session with model: {model}")
        
        mt_chat = self.llm_client.new_chat(model=model, system_prompt=system_prompt)
        if debug:
            print(f"General Instruction:\n{sys_prompt}\n")
            print(f"Initial User Prompt:\n{prompt}\n")

        for round_i in range(self.max_rounds):
            # send messages to LLM and receive response
            response = mt_chat.send_message(prompt)['text']
            parsed = self.parse_llm_response(response, formal_code)

            if debug:
                print(f"LLM Response (Round {round_i + 1}):\n{response}\n")
                print(f"Parsed Result:\n{parsed}\n")


            if parsed.get("parsed", False):
                return {
                    "parsed": True,
                    "verdict": parsed.get("verdict", False),
                    "analysis": parsed.get("analysis", ""),
                }

            prompt = self.make_revision_prompt()

        return {
                    "parsed": False,
                    "verdict": True,
                    "analysis": "",
                }
