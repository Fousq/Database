-- use this file to analyze the indexes
select * from student where name = 'Sion';

select * from student where surname like '%ock%';
select * from student where phone like '%2401%';
select student.name, student.surname, exam_result.mark from student 
inner join exam_result on exam_result.student_id = student.id
where surname like '%ock%';