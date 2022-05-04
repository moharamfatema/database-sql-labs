-- 1
SELECT student_name FROM student WHERE `level` = 'SR' AND student_id in (
	SELECT student_id FROM enrolled WHERE course_code in (
    	SELECT course_code FROM semester_course WHERE prof_id = 1
    )
);

-- 2
SELECT max(age) from student WHERE major = 'History' or student_id IN(
	SELECT student_id FROM enrolled WHERE (course_code, quarter, year) IN (
    	SELECT course_code, quarter, year FROM semester_course WHERE prof_id IN (
        	SELECT prof_id from professor WHERE prof_name = 'Michael Miller'
        )
    )
);

-- 3
SELECT s.student_name, c.name from 
	student as s LEFT join
    enrolled on s.student_id = enrolled.student_id join
    course as c on enrolled.course_code = c.course_code;

-- 4
SELECT prof_name FROM (
    professor JOIN(
        SELECT prof_id as id, count( concat(e.student_id, e.course_code, e.quarter, e.`year`)) as sem_course_enrolls FROM
        enrolled as e
        join semester_course as sc ON sc.course_code = e.course_code AND sc.quarter = e.quarter AND sc.year = e.year
        GROUP by sc.prof_id) Q
	on professor.prof_id = Q.id)
WHERE sem_course_enrolls < 5;

-- 5
SELECT s.student_name from (
	student as s 
    join enrolled as e on s.student_id = e.student_id
    JOIN semester_course as sc on e.course_code = sc.course_code and e.quarter = sc.quarter and e.year = sc.year
) WHERE sc.prof_id = 2;

-- 6
SELECT * FROM course WHERE NOT EXISTS (
    SELECT * FROM semester_course WHERE semester_course.course_code = course.course_code
) UNION SELECT c.course_code, c.name FROM (
	course as c 
    join semester_course as sc on c.course_code = sc.course_code
    join professor as p on sc.prof_id = p.prof_id
    join department as d on p.dept_id = d.DEPT_ID AND d.DEPT_NAME = "Computer Science"
);

-- 7
SELECT student_name FROM student WHERE student_name LIKE "M%" AND age < 20
UNION 
SELECT p.prof_name FROM (
	professor as p
    join semester_course as sc on p.prof_id = sc.prof_id
) WHERE p.prof_name LIKE "M%" and COUNT(concat(sc.course_code,sc.quarter,sc.year)) GROUP by p.prof_id

-- 8
SELECT p.prof_id, p.prof_name from (
        professor as p
        left join semester_course as sc  on p.prof_id = sc.prof_id
        left join enrolled as e on sc.course_code = e.course_code AND sc.quarter = e.quarter and e.year = sc.year)
    	WHERE p.dept_id in (1,2,3,4)
        GROUP by p.prof_id
		HAVING COUNT(all concat(sc.course_code,sc.quarter,sc.year))  < 2;

-- 9

-- all professors w their courses:
(
    select * from 
    (
        select * from 
        (
            select p.prof_id, p.prof_name, concat(sc.course_code,'-', sc.quarter,'-', sc.year) as sck from professor p left join semester_course sc on p.prof_id = sc.prof_id
        )
        prof_course
        -- all prof-course with enrollmens
        left join enrolled on concat(enrolled.course_code,'-', enrolled.quarter,'-', enrolled.year) = prof_course.sck
        -- all enrolls with all students
    )
    q1
    left join student s on s.student_id = q1.student_id
)

UNION

(
    select *  from 
    (
        select * from 
        (
            select p.prof_id, p.prof_name,concat(sc.course_code,'-', sc.quarter,'-', sc.year)as sck from professor p left join semester_course sc on p.prof_id = sc.prof_id
        )
        prof_course
        -- all prof-course with enrollmens
        left join enrolled on concat(enrolled.course_code,'-', enrolled.quarter,'-', enrolled.year) = prof_course.sck
        -- all enrolls with all students
    )
    q2
    right join student s on s.student_id = q2.student_id
);

-- 10

select c.name, c.course_code, p.prof_name, p.prof_id, count(concat(c.course_code,p.prof_id)) as "# times"
from course c
join semester_course sc on c.course_code = sc.course_code
join professor p on p.prof_id = sc.prof_id
group by p.prof_id , c.course_code
having count(concat(c.course_code,p.prof_id)) >= 2;

-- 11

select d.DEPT_NAME , count(sc.course_code) from 
department d 
left join professor p on p.dept_id = d.DEPT_ID
left join semester_course sc on sc.prof_id = p.prof_id
group by d.DEPT_ID
having count(sc.course_code) < 3;