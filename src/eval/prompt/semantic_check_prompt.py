SEMANTIC_SYS_PROMPT="""You are an expert in program verification, especially using Dafny, Verus, and Lean to verify the implementation.
"""

SEMANTIC_INITIAL_PROMPT="""I am giving a verification problem (with natural language description) to a student, and the student has an answer, which passes compilation. I would like you to see if the answer satisfies the general semantic requirements of the problem.

The verification problem generally requires the student to implement a function or a data structure and prove the correctness of the implementation with respect to the specification. The specification is usually given in the form of pre-conditions and post-conditions. The student needs to ensure that the implementation adheres to these specifications. There is a natural language description of the problem, which may provide additional context or requirements for the implementation. The description may require a specific implementation approach, which can not be directly captured by the pre-conditions and post-conditions. For example, the description may require the implementation of a quick sort algorithm and verify its correctness and efficiency, and the pre-conditions and post-conditions only specify the input-output behavior of the sorting function (and the student may implement a bubble sort algorithm, which is correct but does not satisfy the requirement in the description). Even if the student directly call a build-in function for quick sort, it is not allowed, since all the problems are standard, and it is aimed to test student's ability to verify from scratch, instead of if the student is familiar with the packages. Besides, the student might try to use some tricks to cheat the verification, including but not limited to using `sorry', `admit', empty function body, or using existed verified functions without providing their implementations. You need to make sure the student does not use such tricks.

Following I will give you the natural language description, submission ownership information, the teacher-provided scaffold when one can be identified, and the student-authored content. Use the teacher scaffold to understand the specification and surrounding definitions, but use only student-authored content as evidence of cheating. You should only judge if the student implemented the correct algorithm and if the student tried to trick the compiler. You should not judge whether the specifications / pre- or post-conditions are correct. Those will be judged later. You should first give an analysis of the student's answer, explaining whether it meets the requirements or not, and then give a final conclusion in the end. You should wrap your analysis in <analysis> </analysis> tags, and the final conclusion in <conclusion> </conclusion> tags. The conclusion should be either YES or NO, indicating whether the student's answer satisfies the semantic requirements of the problem.

Natural Language Description:
{description}

Submission Ownership:
{ownership_instructions}

Teacher-Provided Scaffold:
{teacher_scaffold}

Student-Authored Content:
{student_sections}

Hard requirements: You should accept all the specifications (sometimes they are there just for simplicity, e.g., we might ask some variable to be larger than 0, just for simplicity). You should only focusing on if the implementation is the one that is required by the natural langauge description, and if the student cheats. You should not challenge any specifications and the proof correctness. All the specifications are provided by teachers and the student do not have the power to change them (the student only provides the implementation and the proof, but not the specification) and the proof correctness will be guaranteed by others.
"""

SEMANTIC_REVISION_PROMPT="""The previous response does not contain the analysis or the conclusion in the required format. Please revise your response to include an analysis wrapped in <analysis> </analysis> tags, and a final conclusion wrapped in <conclusion> </conclusion> tags. The conclusion should be either YES or NO, indicating whether the student's answer satisfies the semantic requirements of the problem."""
