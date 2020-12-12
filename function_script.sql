-- Add trigger that will update column updated_datetime to current date in case of updating any of student.
create or replace function update_student_last_update_time()
returns trigger
language plpgsql as $$
begin
    update student set updated = now() where id = OLD.id;

    return OLD;
end;$$;

drop trigger if exists update_student_last_update_time_trigger on student;

create trigger update_student_last_update_time_trigger
after update on student
for each row
-- add this condition to avoid stack overflow
when (pg_trigger_depth() = 0)
execute procedure update_student_last_update_time();

-- Add validation on DB level that will check username on special characters (reject student name with next characters '@', '#', '$')
-- use constraints or triggers. validation on DB level?
alter table student
add constraint check_student_name check (name not similar to '%(@|#|$)%');

-- Create snapshot that will contain next data: student name, student surname, subject name, mark
create table data_snapshot as 
(select student.name as student_name, student.surname as student_surname, subject.name as subject_name,
 exam_result.mark as exam_result_mark from student
inner join exam_result on exam_result.student_id = student.id
inner join subject on subject.id = exam_result.subject_id);

-- Create function that will return average mark for input user
create or replace function average_student_mark(selected_student_id bigint) 
returns double precision
language plpgsql as $$
declare average_mark double precision;
begin
    select avg(exam_result.mark) into average_mark 
    from exam_result where exam_result.student_id = selected_student_id;

    return average_mark;
end;$$;


-- Create function that will return avarage mark for input subject name
create or replace function average_subject_mark(subject_name varchar) 
returns double precision
language plpgsql as $$
declare average_mark double precision;
begin
    select avg(exam_result.mark) into average_mark 
    from exam_result 
    inner join subject on exam_result.subject_id = subject.id 
    and subject.name = subject_name;

    return average_mark;
end;$$;

-- Create function that will return student at "red zone" (red zone means at least 2 marks <=3)
create or replace function red_zone_students() 
returns table (id bigint, 
name varchar(100), 
surname varchar(100),
birthday date,
phone char(16),
primary_skill_name varchar(100))
language plpgsql as $$
begin
    return query select distinct student.id, student.name, 
    student.surname, student.birthday, student.phone, primary_skill.name 
    from student 
    inner join primary_skill on primary_skill.id = student.primary_skill_id
    inner join exam_result on exam_result.student_id = student.id
    where (select count(*) from exam_result where student_id = student.id and mark <= 3) >= 2;
end;$$;