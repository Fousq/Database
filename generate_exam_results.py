import random

STATEMENT_EXAM_RESULT = "insert into exam_result(student_id, subject_id, mark) values ({0}, {1}, {2});\n"

if __name__ == "__main__":
    file = open('./exam_results_data.sql', 'w')
    # students
    for i in range(1, 100_001):
        # subject
        for j in range(1, 1_001):
            file.write(STATEMENT_EXAM_RESULT.format(i, j, random.randint(1, 5)))
