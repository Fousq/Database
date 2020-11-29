# Main Task

Database task:

1. Design database for CDP program. Your DB should store information about students (name, surname, date of birth, phone numbers, primary skill, created_datetime, updated_datetime etc.), subjects (subject name, tutor, etc.) and exam results (student, subject, mark).
2. Please add appropriate constraints (primary keys, foreign keys, indexes, etc.)
3. Design such kind of database for PostrgeSQL. Show your design in some suitable way (PDF, PNG, etc). (2 points)
4. Try different kind of indexes (B-tree, Hash, GIN, GIST) for your fields. Analyze performance for each of the indexes (use ANALYZE and EXPLAIN). Check the size of the index. Try to set index before inserting test data and after. What was the time? Test data:
    a. 100K of users
    b. 1K of subjects
    c. 1 million of marks

Test queries:

a. Find user by name (exact match)
b. Find user by surname (partial match)
c. Find user by phone number (partial match)
d. Find user with marks by user surname (partial match)

Add to separate document your investigation. (2 points)

1. Add trigger that will update column updated_datetime to current date in case of updating any of student. (1 point)
2. Add validation on DB level that will check username on special characters (reject student name with next characters '@', '#', '$') (1 point)
3. Create snapshot that will contain next data: student name, student surname, subject name, mark (snapshot means that in case of changing some data in source table – your snapshot should not change) (1 point)
4. Create function that will return average mark for input user (1 point)
5. Create function that will return avarage mark for input subject name (1 point)
6. Create function that will return student at "red zone" (red zone means at least 2 marks <=3) (1 point)
7. Extra point (1 point). Show in tests (java application) transaction isolation phenomena. Describe what kind of phenomena is it and how did you achieve it.
8. Extra point 2 (1 point). Implement immutable data trigger. Create new table student_address. Add several rows with test data and do not give acces to update any information inside it. Hint: you can create trigger that will reject any update operation for target table, but save new row with updated (merged with original) data into separate table.

Other rules:

* Please, add your changes to GIT task by task. It will be better to check your result based on such kind of history
* Database table/constraint creation – separate file
* Test data for indexes – separate file

Result of your task is

* DB design in suitable format
* Index investigation document
* SQL file that will show to your mentor and tutor how you did your homework