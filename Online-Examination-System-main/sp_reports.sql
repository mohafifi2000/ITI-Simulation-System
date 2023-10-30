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
create proc get_stud_grades @stud_id numeric(18,0)
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
create proc get_course_topics @crs_id int
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
create proc get_ques_choice @ex_id int
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
create proc get_stud_answers @ex_id int, @stud_id numeric(18,0)
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