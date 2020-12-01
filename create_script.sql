create or replace primary_skill(
    id bigserial primary key,
    name varchar(100) not null
);

create or replace table student(
    id bigserial primary key,
    name varchar(100) not null,
    surname varchar(100) not null,
    birthday date not null,
    phone char(16) not null,
    primary_skill_id bigint,
    created datetime not null,
    updated datetime,
    foreign key (primary_skill_id) references (primary_skill.id)
);

create or replace tutor(
    id bigserial primary key,
    name varchar(100) not null
);

create or replace subject(
    id bigserial primary key,
    name varchar(100) not null,
    tutor_id bigint not null,
    foreign key (tutor_id) references (tutor.id)
);

create or replace exam_result(
    student_id bigint not null,
    subject_id bigint not null,
    mark int not null,
    foreign key (student_id) references (student.id),
    foreign key (subject_id) references (subject.id)
);