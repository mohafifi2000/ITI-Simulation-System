use ITI_Simulation;
go
create proc get_courses 
as
	begin try
		select course_name, duration, assessment_type
		from courses
	end try
	begin catch
		select 'error occured'
	end catch
go
------------------------------------------
create proc get_tracks 
as
	begin try
		select track_name, type, employee_name as supervisor
		from tracks t join employees e
		on t.supervisor_id = e.employee_id
	end try
	begin catch
		select 'error occured'
	end catch
go
----------------------------------------------
create proc get_branches
as
	begin try
		select city, opening_date, employee_name as manager
		from branches b join employees e
		on b.manager_id = e.employee_id
	end try
	begin catch
		select 'error occured'
	end catch
go
---------------------------------------------------
create proc get_evaluation
as
	begin try
		select course_name, AVG(course_rating) as course_rating
		from courses c join student_evaluation ev
		on c.course_id = ev.course_id
		group by course_name
		order by course_rating desc
	end try
	begin catch
		select 'error occured'
	end catch
go
-------------------------------------------------
create proc get_intake_applicants
as
	begin try
		select intake_number, count(applicant_id) number_of_applicants
		from applicant_intake
		group by intake_number
		order by intake_number
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------
create proc get_employees
as
	begin try
		select employee_name, job_title, salary
		from employees
		order by salary desc
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------
create proc get_applicant_scores @id numeric (18,0)
as
	begin try
		select applicant_id, intake_number, english_score, iq_score, soft_skills_interview_score, final_interview_score
		from applicant_intake 
		where applicant_id = @id
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------
create proc get_jobs
as 
	begin try
		select current_job, job_type, company
		from graduates 
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------
create proc get_graduates
as
	begin try
		select graduate_id as id, applicant_name as name, g.intake_number, 
		t.track_name, graduation_date, faculty, university,
		job_type, current_job, salary,company
		from graduates g
		join students s
		on g.graduate_id = s.student_id and g.intake_number = s.intake_number
		join applicant_intake app_in 
		on s.student_id = app_in.applicant_id and s.intake_number = app_in.intake_number
		join applicants app
		on app_in.applicant_id = app.applicant_id
		join applicant_track 
		on app.applicant_id = applicant_track.applicant_id
		join tracks t
		on applicant_track.track_id = t.track_id
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------
create proc get_specific_graduate @id numeric(18,0)
as
	begin try
		select graduate_id as id, applicant_name as name, g.intake_number, 
		t.track_name, graduation_date, faculty, university,
		job_type, current_job, salary,company
		from graduates g
		join students s
		on g.graduate_id = s.student_id and g.intake_number = s.intake_number
		join applicant_intake app_in 
		on s.student_id = app_in.applicant_id and s.intake_number = app_in.intake_number
		join applicants app
		on app_in.applicant_id = app.applicant_id
		join applicant_track 
		on app.applicant_id = applicant_track.applicant_id
		join tracks t
		on applicant_track.track_id = t.track_id
		where graduate_id = @id
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------
create proc get_specific_instructor @id numeric(18,0)
as
	begin try
		select employee_name as instructor_name, course_name, track_name, city as branch
		from employees join track_course_instructor tci on employee_id = instructor_id
		join courses on tci.course_id = courses.course_id
		join tracks t on tci.track_id = t.track_id
		join track_branch tb on t.track_id = tb.track_id
		join branches b on tb.branch_id = b.branch_id
		where employee_id = @id
	end try
	begin catch
	end catch
go
-----------------------------------------------------
create proc Get_specific_course @c_id int
as 
	begin try
		select c.course_id, course_name, duration, assessment_type,topic_name
		from courses c join topics t
		on c.course_id = @c_id and c.course_id = t.course_id
	end try
	begin catch 
		select 'error occured'
	end catch 
go
-----------------------------------------------------
create procedure get_specific_track @id int
as
	begin try
		select track_name, type, start_date, end_date, employee_name as supervisor
		from tracks t join employees e
		on t.supervisor_id = e.employee_id
		where track_id = @id
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------
create procedure get_track_branch
as
	begin try
		select b.branch_id, b.city as branch_name, t.track_id, t.track_name
		from branches b join track_branch tb on b.branch_id = tb.branch_id
		join tracks t on tb.track_id = t.track_id
	end try
	begin catch
		select 'error occured'
	end catch
go	
-----------------------------------------------------
create proc insert_certificate @student numeric(18,0), @intake int, @cert nvarchar(100), @platform nvarchar(50), @status nvarchar(15)
as
	begin try
		insert into certificates
		values(@student,@intake,@cert,@platform,@status)
	end try
	begin catch
		select 'error occured'
	end catch
go
--------------------------------------------------------
create proc insert_freelance @student numeric(18,0), @intake int, @task_description nvarchar(90), @platform nvarchar(30), @duration int, @cost int, @client_name nvarchar(50),@status nvarchar(15)
as
	begin try
		insert into freelance 
		values(@student, @intake , @task_description, @platform, @duration, @cost, @client_name, @status)
	end try
	begin catch
		select 'error occured'
	end catch
go
---------------------------------------------------------------
create proc insert_branch @id int ,@city nvarchar(50), @manager int
as
	begin try
		insert into branches
		values(@id,@city,getdate(),@manager)
	end try
	begin catch
		select 'error occured'
	end catch
go
----------------------------------------------------------------------
create proc insert_track @id int ,@name nvarchar(50),@start date,@end date,@type nvarchar(50),@supervisor numeric(18,0)
as
	begin try
		insert into tracks
		values(@id,@name,@start,@end,@type,@supervisor)
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------------------------
create proc insert_graduate @id numeric(18,0) ,@intake int
as
	begin try
		insert into graduates(graduate_id,intake_number,graduation_date)
		values(@id,@intake,getdate())
	end try
	begin catch
		select 'error occured'
	end catch
go
------------------------------------------------------------------------

------------------------------------------------------------------------
create proc delete_from_table @table_name varchar(50), @condition_id varchar(50) , @column_name varchar(50)
as
	begin try
		execute ('DELETE FROM ' + @table_name +' WHERE '+@column_name+'=' + @condition_id)
	end try
	begin catch
		select 'error occured'
	end catch
GO
-------------------------------------------------------------------------
create proc update_table @table_name varchar(50), @column_to_update varchar(50), @value varchar(50), @condition_column varchar(50), @condition_id varchar(50)
as
	begin try
		execute ('Update ' + @table_name +
		' SET '+@column_to_update+' = ' + @value + 
		' WHERE '+ @condition_column + ' = '+' @condition_id' )
	end try
	begin catch
		select 'error occured'
	end catch
go
--------------------------------------------------------------------------
create procedure update_hiring @id numeric(18,0) ,@intake int, @job nvarchar(50),
				@company nvarchar(50), @type nvarchar(30), @date date, @salary int
as
	begin try
		update graduates 
		set current_job = @job, company = @company, job_type = @type, employment_date = @date, salary = @salary
		where graduate_id = @id and intake_number = @intake
	end try
	begin catch
		select 'error occured'
	end catch
go
-------------------------------------------------------------------------
create procedure update_military_status
as
	begin try
		update applicants 
		set military_status = null
		where gender = 'Female'
	end try
	begin catch
		select 'error occured'
	end catch
go
--------------------------------------------------------------------------
create procedure update_salary
as
	begin try
		update graduates 
		set salary = null
		where current_job = null
		end try
	begin catch
		select 'error occured'
	end catch
go
-------------------------------------------------------------------------
--reports
create proc get_studs_by_track @track int 
as
	begin try
		select apt.track_id, s.intake_number, ap.*, s.tasks_grade, s.correctives 
		from students s join applicant_intake ai on s.student_id = ai.applicant_id and s.intake_number = ai.intake_number
		join applicants ap on ai.applicant_id = ap.applicant_id
		join applicant_track apt on ap.applicant_id = apt.applicant_id
		where track_id = @track
	end try
	begin catch
		select 'error occured'
	end catch
go
-------------------------------
alter proc get_stud_grades @stud_id numeric(18,0)
as
	begin try
		select c.course_name, concat(round(sum(answer_grade) * 100 / 150,2),'%' ) as grade 
		from student_answers ans join exam_questions q on ans.question_id = q.question_id
		join courses c on q.course_id = c.course_id
		where student_id = 20062573011238
		group by c.course_name
	end try
	begin catch
		select 'error occured'
	end catch
go
------------------------------
create proc get_instructor_courses @ins_id numeric(18,0)
as
	begin try
		select course_name, count(student_id) number_of_students
		from courses c join track_course_instructor ins_crs on ins_crs.course_id = c.course_id
		join student_evaluation st_crs on c.course_id = st_crs.course_id
		where instructor_id = @ins_id 
		group by course_name
	end try
	begin catch
		select 'error occured'
	end catch
go
------------------------------------
alter proc get_course_topics @crs_id int
as
	begin try
		select topic_name, course_name
		from topics t join courses c
		on c.course_id = @crs_id and c.course_id = t.course_id
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------
alter proc get_ques_choice @ex_id int
as
	begin try
		select question, choice_value
		from exam_questions ex join question_choices ch
		on ex.question_id = ch.question_id
		where exam_id = @ex_id
	end try
	begin catch
		select 'error occured'
	end catch
go
----------------------------------------------
alter proc get_stud_answers @ex_id int, @stud_id numeric(18,0)
as
	begin try
		select question, student_answer
		from exam_questions ex join student_answers s
		on ex.question_id = s.question_id 
		where s.student_id = @stud_id and ex.exam_id = @ex_id
	end try
	begin catch
		select 'error occured'
	end catch
go
-----------------------------------------------------------------------
--Student answers insertion and correction
create proc ans_exam (@st_id1 numeric,@intake1 int,@track_id1 int, @ques_id1 int, @st_ans1 varchar(50) )
as
begin try
set @intake1=45
set @intake1=(select top(1)ai.intake_number from applicant_intake ai join
 applicant_track ak on ak.applicant_id=ai.applicant_id where
 ai.applicant_id=@st_id1 and ak.track_id=@track_id1)
declare @exam_id int 
set @exam_id=(select top(1)exam_id from generated_exam1 where st_id=@st_id1)
declare @ans_grade int 
set @ans_grade=0
if (@st_ans1 = (select cast(model_answer as varchar(50)) from exam_questions where question_id=@ques_id1))
begin 
set @ans_grade =10
end
insert into student_answers (student_id,intake_number,question_id,student_answer,grade,exam_id)
values(@st_id1,@intake1,@ques_id1,@st_ans1,@ans_grade,@exam_id)
end try

begin catch
Select 'Error occured! Please enter valid inputs'
end catch
go
-----------------------------------------------------------
create proc generate_exam3(@stud_id int, @crs_id int)
AS
    declare @t table(st_id int,ques_id int,exam_id int,question varchar(100))
  
    declare @exam_id int;
    set @exam_id = (select COUNT (distinct exam_id)+1 FROM exam_questions );
  
  declare @i int
  declare @ques_id int
  declare @question varchar(100)
  set @i =0
  while @i<5
  begin
      set @ques_id=(select top(1)question_id from exam_questions
      Where course_id = @crs_id and type = 'MCQ' ORDER BY NEWID())
            
    if (@ques_id not in (select ques_id FROM @t))
    begin
      
      set @question=(select top(1)question from exam_questions
      Where question_id=@ques_id 
    )
    insert into @t(st_id,ques_id,question,exam_id)
    values(@stud_id,@ques_id,@question,@exam_id)
    set @i=@i+1
    end
    end
    --TF
    set @i=0
    while @i< 5
  begin
      set @ques_id=(select top(1)question_id from exam_questions
      Where course_id = @crs_id and type = 'TF' ORDER BY NEWID())

    if (@ques_id not in (select ques_id FROM @t))
    begin
      
      set @question=(select top(1)question from exam_questions
      Where question_id=@ques_id 
    )
    insert into @t(st_id,ques_id,question,exam_id)
    values(@stud_id,@ques_id,@question,@exam_id)
    set @i=@i+1
    end
    
  end
  select * from @t


--Exam Generation

create proc generate_exam(@stud_id int, @crs_id int,@question_count int)
AS

    declare @exam_id int;
    set @exam_id = (select COUNT (distinct exam_id)+1 FROM exam_questions );
	declare @mcq_count int
	set @mcq_count= @question_count/2
	declare @tf_count int
	set @tf_count=@question_count-@mcq_count
	declare @i int
	declare @ques_id int
	declare @question varchar(100)
	truncate table generated_exam1
	set @i =0
	while @i<@mcq_count
	begin
	    set @ques_id=(select top(1)question_id from exam_questions
	    Where course_id = @crs_id and type = 'MCQ' ORDER BY NEWID())

		if (@ques_id not in (select ques_id FROM generated_exam1))
		begin
	    
	    set @question=(select top(1)question from exam_questions
	    Where question_id=@ques_id 
		)
		insert into dbo.generated_exam1(st_id,ques_id,question,exam_id)
		values(@stud_id,@ques_id,@question,@exam_id)
		set @i=@i+1
		end
		end
		--TF
		set @i=0
		while @i< @tf_count 
	begin
	    set @ques_id=(select top(1)question_id from exam_questions
	    Where course_id = @crs_id and type = 'TF' ORDER BY NEWID())

		if (@ques_id not in (select ques_id FROM generated_exam1))
		begin
	    
	    set @question=(select top(1)question from exam_questions
	    Where question_id=@ques_id 
		)
		insert into dbo.generated_exam1(st_id,ques_id,question,exam_id)
		values(@stud_id,@ques_id,@question,@exam_id)
		set @i=@i+1
		end
	end