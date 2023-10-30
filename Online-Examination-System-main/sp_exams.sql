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