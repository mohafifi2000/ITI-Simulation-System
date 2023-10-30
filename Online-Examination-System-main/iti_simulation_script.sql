--use master drop database ITI_Simulation
create database ITI_Simulation;
go
use ITI_Simulation;
go
create table applicant_intake
(
applicant_id int,
intake_number int,
english_score int not null,
iq_score int not null, 
soft_skills_interview_score int not null,
final_interview_score int not null
constraint app_pk primary key(applicant_id,intake_number)
);
go

create table applicants
(
applicant_id int primary key,
student_name varchar(50) not null,
gender varchar (10) not null,
birth_date date not null,
address varchar(1) not null,
email varchar(50) not null,
phone_number varchar(15) not null,
linkedin_account varchar(100),
military_status varchar (30) not null,
martial_status varchar(20),
faculty varchar(100) not null,
university varchar(50) not null,
graduation_year int not null,
grade int not null,
english_score int not null,
iq_score int not null, 
soft_skills_interview_score int not null,
final_interview_score int not null
);
go
create table courses
(
course_id int primary key,
course_name varchar(50) not null,
duration int not null,
assessment_type varchar(30) not null,
);
go

create table exam_questions
(
question_id int primary key,
exam_id int not null,
question text not null,
type varchar(30) not null,
model_answer text not null,
course_id int not null,
constraint qu_crs_fk foreign key (course_id) references courses(course_id)
);
go

create table question_choices 
(
question_id int not null,
choice char(1) not null,
constraint qu_ch_pk primary key (question_id,choice),
constraint qu_ch_fk foreign key (question_id) references exam_questions(question_id)
);
go

create table topics 
(
topic_id int primary key,
topic_name varchar(100) not null,
course_id int,
constraint tpc_crs_fk foreign key(course_id) references courses(course_id)
);
go

create table branches
(
branch_id int primary key,
city varchar(50) not null,
opening_date date,
manager_id int not null
);
go

create table employees
(
employee_id int primary key,
employee_name varchar(50) not null,
date_of_birth date not null,
phone_number varchar(15) not null,
martial_status varchar(10),
salary int,
job_title varchar(50) not null,
branch_id int,
constraint emp_bch_fk foreign key (branch_id) references branches(branch_id)
);
go

alter table branches
add constraint bch_mgr_fk foreign key (manager_id) references employees(employee_id);
go

create table healthcare 
(
visit_id int primary key,
diagnosis varchar(100) not null,
clinic varchar(100) not null,
inclusive_or_exclusive varchar(10) not null,
sick_leave bit not null,
employee_id int not null,
constraint emp_care_fk foreign key (employee_id) references employees(employee_id)
);
go

create table tracks
(
track_id int primary key,
track_name varchar(50) not null,
start_date date,
end_date date,
type varchar(50) not null,
supervisor_id int not null,
constraint trk_super_fk foreign key (supervisor_id) references employees(employee_id)
);
go

create table facilities 
(
facility_id int primary key,
facility_name varchar(30) not null,
facility_type varchar(30) not null,
branch_id int not null,
constraint fac_brh_fk foreign key (branch_id) references branches(branch_id)
);
go



create table students 
(
student_id int,
intake_number int,
track_id int, 
emergency_contact varchar(15),
tasks_grade int not null,
correctives int not null,
constraint std_pk primary key (student_id,intake_number,track_id),
constraint app_std_fk foreign key (student_id,intake_number) references applicant_intake(applicant_id,intake_number)
);
go

create table graduation_projects
(
student_id int,
intake_number int,
project_name varchar(50) not null,
bonus bit not null,
project_grade int not null,
status varchar(30),
constraint grad_pk primary key (student_id,intake_number,project_name),
constraint grad_std_fk foreign key (student_id,intake_number) references applicant_intake(applicant_id,intake_number)
);
go
create table graduates
(
graduate_id int,
intake_number int,
graduation_date date not null,
current_job varchar(50),
company varchar(50),
job_type varchar(30),
previous_job varchar(50),
employment_date date,
salary int,
constraint graduate_pk primary key (graduate_id,intake_number,graduation_date),
constraint app_grad_fk foreign key (graduate_id,intake_number) references applicant_intake(applicant_id,intake_number)
);
go

create table certificates
(
student_id int,
intake_number int,
certificate_name varchar(100) not null,
platform varchar(50),
status bit not null,
constraint cert_pk primary key (student_id,intake_number,certificate_name),
constraint cert_std_fk foreign key (student_id,intake_number) references applicant_intake(applicant_id,intake_number)
);
go

create table freelance 
(
student_id int,
intake_number int,
task_description text,
platform varchar(30),
duration int,
cost int,
client_name varchar(50),
status bit not null,
constraint free_pk primary key (student_id,intake_number,status),
constraint free_std_fk foreign key (student_id,intake_number) references applicant_intake(applicant_id,intake_number)
);
go

create table applicant_track
(
applicant_id int references applicants(applicant_id),
track_id int references tracks(track_id)
constraint app_trk_pk primary key (applicant_id,track_id)
);
go

create table applicant_branch
(
applicant_id int references applicants(applicant_id),
branch_id int references branches(branch_id)
constraint app_brh_pk primary key (applicant_id,branch_id)
);
go

create table track_branch
(
track_id int references tracks(track_id),
branch_id int references branches(branch_id)
constraint trk_brh_pk primary key (track_id,branch_id)
);
go

create table student_answers
(
student_id int references applicants(applicant_id),
question_id int references exam_questions(question_id), 
student_answer text not null,
answer_grade bit,
constraint std_ans_pk primary key (student_id,question_id)
);
go

create table student_evaluation
(
student_id int references applicants(applicant_id),
course_id int references courses(course_id),
course_rating int not null,
facility_rating int not null,
instructor_rating int not null,
constraint std_eval_pk primary key (student_id,course_id)
);
go

create table applicant_track_branch_techInterview
(
applicant_id int not null, 
track_id int not null,
branch_id int not null,
tech_interview_score int not null
constraint mv_tbl_pk primary key (applicant_id,track_id,branch_id),
constraint mv_trk_fk foreign key (track_id) references tracks(track_id),
constraint mv_brh_fk foreign key (branch_id) references branches(branch_id)
);
go

create table track_course_instructor 
(
track_id int references tracks(track_id),
course_id int references courses(course_id),
instructor_id int references employees(employee_id),
online_or_offline varchar(10),
constraint trk_crs_ins_pk primary key (track_id,course_id,instructor_id)
);
go


