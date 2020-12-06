drop table if exists exam_result;
drop table if exists student;
drop table if exists primary_skill;
drop table if exists subject;
drop table if exists tutor;


create table if not exists primary_skill(
    id bigserial primary key,
    name varchar(100) not null
);

create table if not exists student(
    id bigserial primary key,
    name varchar(100) not null,
    surname varchar(100) not null,
    birthday date not null,
    phone char(16) not null,
    primary_skill_id bigint,
    created timestamp  not null,
    updated timestamp,
    foreign key (primary_skill_id) references primary_skill(id)
);

create table if not exists tutor(
    id bigserial primary key,
    name varchar(100) not null
);

create table if not exists subject(
    id bigserial primary key,
    name varchar(100) not null,
    tutor_id bigint not null,
    foreign key (tutor_id) references tutor(id)
);

create table if not exists exam_result(
    student_id bigint not null,
    subject_id bigint not null,
    mark int not null,
    foreign key (student_id) references student(id),
    foreign key (subject_id) references subject(id)
);