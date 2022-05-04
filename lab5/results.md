# 1.

## Query

```sql
SELECT student_name FROM student WHERE `level` = 'SR' AND student_id in (
	SELECT student_id FROM enrolled WHERE course_code in (
    	SELECT course_code FROM semester_course WHERE prof_id = 1
    )
)
```

## Result

|student_name	
|---
Maria White	
Charles Harris	
Angela Martinez	


# 2.

## Query

```sql
SELECT max(age) from student WHERE major = 'History' or student_id IN(
	SELECT student_id FROM enrolled WHERE (course_code, quarter, year) IN (
    	SELECT course_code, quarter, year FROM semester_course WHERE prof_id IN (
        	SELECT prof_id from professor WHERE prof_name = 'Michael Miller'
        )
    )
);
```

## Results

**22**

# 3.

## Query

```sql
SELECT s.student_name, c.name from 
	student as s LEFT join
    enrolled on s.student_id = enrolled.student_id left join
    course as c on enrolled.course_code = c.course_code;

```

## Results
 
student_name|	name	
---|---
Maria White	|Data Structures	
Maria White	|Data Structures	
Maria White	|Archaeology of the Incas	
Maria White	|Aviation Accident Investigation	
Charles Harris|	Data Structures	
Charles Harris|	Database Systems	
Charles Harris|	Operating System Design	
Charles Harris|	Air Quality Engineering	
Susan Martin	|Database Systems	
Susan Martin	|Operating System Design	
Susan Martin	|Archaeology of the Incas	
Joseph Thompson|	Data Structures	
Joseph Thompson|	American Political Parties	
Joseph Thompson|	Social Cognition	
Christopher Garcia|	Operating System Design	
Angela Martinez	|Data Structures	
Thomas Robinson	|Database Systems	
Thomas Robinson	|Introductory Latin	
Margaret Clark	|Data Structures	
Margaret Clark	|Operating System Design	
Margaret Clark	|Archaeology of the Incas	
Margaret Clark	|Aviation Accident Investigation	
Margaret Clark	|Air Quality Engineering	
Juan Rodriguez	|Data Structures	
Juan Rodriguez	|Archaeology of the Incas	
Juan Rodriguez	|Aviation Accident Investigation	
Dorthy Lewis	|Data Structures	
Dorthy Lewis	|Database Systems	
Dorthy Lewis	|Aviation Accident Investigation	
Dorthy Lewis	|Air Quality Engineering	
Dorthy Lewis	|Introductory Latin	
Daniel Lee	|Data Structures	
Daniel Lee	|Archaeology of the Incas	
Daniel Lee	|Air Quality Engineering	
Daniel Lee	|Introductory Latin	
Daniel Lee	|American Political Parties	
Lisa Walker|	Data Structures	
Lisa Walker|	Archaeology of the Incas	
Lisa Walker|	American Political Parties	
Lisa Walker|	Social Cognition	
Paul Hall	|Data Structures	
Paul Hall	|Operating System Design	
Paul Hall	|Social Cognition	
Nancy Allen|	Operating System Design	
Nancy Allen|	Aviation Accident Investigation	
Mark Young	|Data Structures	
Mark Young	|Database Systems	
Mark Young	|Operating System Design	
Mark Young	|Aviation Accident Investigation	
Mark Young	|Air Quality Engineering	
Luis Hernandez|	Data Structures	
Luis Hernandez|	Data Structures	
Luis Hernandez|	Data Structures	
Luis Hernandez|	Database Systems	
Luis Hernandez|	Operating System Design	
Luis Hernandez|	Air Quality Engineering	
Donald King	|    NULL
George Wright|	    NULL
	
# 4.

## Query

```sql
SELECT prof_name FROM (
    professor JOIN(
        SELECT prof_id as id, count( concat(e.student_id, e.course_code, e.quarter, e.`year`)) as sem_course_enrolls FROM
        enrolled as e
        join semester_course as sc ON sc.course_code = e.course_code AND sc.quarter = e.quarter AND sc.year = e.year
        GROUP by sc.prof_id) Q
	on professor.prof_id = Q.id)
WHERE sem_course_enrolls < 5;
```

## Result

prof_name|
---|	
John Williams	
Patricia Jones	

# 5.

## Query

```sql
SELECT s.student_name from (
	student as s 
    join enrolled as e on s.student_id = e.student_id
    JOIN semester_course as sc on e.course_code = sc.course_code and e.quarter = sc.quarter and e.year = sc.year
) WHERE sc.prof_id = 2;
```

## Result

student_name|
---|	
Maria White	
Margaret Clark	
Luis Hernandez	
Joseph Thompson	
Lisa Walker	
Paul Hall	

# 6.

## Query

```sql
SELECT * FROM course WHERE NOT EXISTS (
    SELECT * FROM semester_course WHERE semester_course.course_code = course.course_code
) UNION SELECT c.course_code, c.name FROM (
	course as c 
    join semester_course as sc on c.course_code = sc.course_code
    join professor as p on sc.prof_id = p.prof_id
    join department as d on p.dept_id = d.DEPT_ID AND d.DEPT_NAME = "Computer Science"
);
```

## Result

course_code|	name	|
---|---|
CC21	|Patent Law	
CC22	|Urban Economics	
CC23	|Organic Chemistry	
CC19	|Perception	
CC10	|Data Structures	
CC20	|Multivariate Analysis	
CC12	|Operating System Design	

# 7.
## Query

```sql
SELECT student_name FROM student WHERE student_name LIKE "M%" AND age < 20
UNION SELECT name FROM (
    (SELECT p.prof_name as name , count(ALL concat(sc.course_code,sc.quarter,sc.year)) as prof_courses FROM 
        professor as p
        join semester_course as sc on p.prof_id = sc.prof_id AND p.prof_name LIKE "M%"
    	GROUP BY p.prof_id) Q
) WHERE Q.prof_courses > 2;
```

## Result

student_name|
---|	
Margaret Clark	
Mark Young	
Michael Miller	

# 8.
## Query

```sql
SELECT p.prof_id, p.prof_name from (
        professor as p
        left join semester_course as sc  on p.prof_id = sc.prof_id
        left join enrolled as e on sc.course_code = e.course_code AND sc.quarter = e.quarter and e.year = sc.year)
    	WHERE p.dept_id in (1,2,3,4)
        GROUP by p.prof_id
		HAVING COUNT(all concat(sc.course_code,sc.quarter,sc.year))  < 2;
```

## Result

prof_id|	prof_name	|
---|---|
3	|Mary Johnson	
7	|Robert Brown	

# 9.
## Query

```sql
-- all professors w their courses:
(
    select  s.student_id as "Student ID", s.student_name as "Student Name",pid as "Professor ID", pname as "Professor Name", sck as "Course" from 
    (
        select pid, pname, sck, e.student_id from 
        (
            select p.prof_id as pid, p.prof_name as pname, concat(sc.course_code,'-', sc.quarter,'-', sc.year) as sck from professor p left join semester_course sc on p.prof_id = sc.prof_id
        )
        prof_course
        -- all prof-course with enrollmens
        left join enrolled e on concat(e.course_code,'-', e.quarter,'-', e.year) = sck
        -- all enrolls with all students
    )
    q1
    left join student s on s.student_id = q1.student_id
)

UNION

(
    select   s.student_id as "Student ID", s.student_name as "Student Name",pid as "Professor ID", pname as "Professor Name", sck as "Course" from 
    (
        select pid , pname, sck, e.student_id from 
        (
            select p.prof_id as pid, p.prof_name as pname, concat(sc.course_code,'-', sc.quarter,'-', sc.year)as sck from professor p left join semester_course sc on p.prof_id = sc.prof_id
        )
        prof_course
        -- all prof-course with enrollmens
        left join enrolled e on concat(e.course_code,'-', e.quarter,'-', e.year) = sck
        -- all enrolls with all students
    )
    q2
    right join student s on s.student_id = q2.student_id
);
```

## Result

Student ID	|Student Name	|Professor ID	|Professor Name	|Course	
---|---|---|---|---
201	|Maria White	|6	    |Michael Miller	|CC10-Spring-2012	
201	|Maria White	|2	    |James Smith	|CC10-Spring-2013	
201	|Maria White	|1	    |Ivana Teach	|CC13-Fall-2013	
201	|Maria White	|6	    |Michael Miller	|CC14-Spring-2013	
202	|Charles Harris	|1	    |Ivana Teach	|CC10-Spring-2014	
202	|Charles Harris	|1	    |Ivana Teach	|CC11-Fall-2012	
202	|Charles Harris	|6	    |Michael Miller	|CC12-Summer-2012	
202	|Charles Harris	|1	    |Ivana Teach	|CC15-Spring-2014	
203	|Susan Martin	|6	    |Michael Miller	|CC11-Spring-2016	
203	|Susan Martin	|6	    |Michael Miller	|CC12-Summer-2012	
203	|Susan Martin	|6	    |Michael Miller	|CC13-Fall-2014	
204	|Joseph Thompson	|1	    |Ivana Teach	|CC10-Spring-2015	
204	|Joseph Thompson	|1	    |Ivana Teach	|CC17-Fall-2016	
204	|Joseph Thompson	|2	    |James Smith	|CC18-Spring-2016	
205	|Christopher Garcia	|6	    |Michael Miller	|CC12-Spring-2015	
206	|Angela Martinez	|4	    |John Williams	|CC10-Fall-2016	
207	|Thomas Robinson	|6	    |Michael Miller	|CC11-Spring-2016	
207	|Thomas Robinson	|1	    |Ivana Teach	|CC16-Spring-2016	
208	|Margaret Clark	|2	    |James Smith	|CC10-Spring-2013	
208	|Margaret Clark	|5	    |Patricia Jones	|CC12-Summer-2016	
208	|Margaret Clark	|1	    |Ivana Teach	|CC13-Fall-2013	
208	|Margaret Clark	|1	    |Ivana Teach	|CC14-Fall-2015	
208	|Margaret Clark	|1	    |Ivana Teach	|CC15-Spring-2015	
209	|Juan Rodriguez	|6	    |Michael Miller	|CC10-Spring-2012	
209	|Juan Rodriguez	|1	    |Ivana Teach	|CC13-Fall-2013	
209	|Juan Rodriguez	|6	    |Michael Miller	|CC14-Spring-2013	
210	|Dorthy Lewis	|1	    |Ivana Teach	|CC10-Spring-2014	
210	|Dorthy Lewis	|1	    |Ivana Teach	|CC11-Fall-2012	
210	|Dorthy Lewis	|6	    |Michael Miller	|CC14-Spring-2013	
210	|Dorthy Lewis	|1	    |Ivana Teach	|CC15-Spring-2014	
210	|Dorthy Lewis	|1	    |Ivana Teach	|CC16-Spring-2016	
211	|Daniel Lee	|1	    |Ivana Teach	|CC10-Spring-2014	
211	|Daniel Lee	|6	    |Michael Miller	|CC13-Fall-2014	
211	|Daniel Lee	|1	    |Ivana Teach	|CC15-Spring-2014	
211	|Daniel Lee	|1	    |Ivana Teach	|CC16-Spring-2016	
211	|Daniel Lee	|1	    |Ivana Teach	|CC17-Fall-2016	
212	|Lisa Walker	|1	    |Ivana Teach	|CC10-Spring-2015	
212	|Lisa Walker	|6	    |Michael Miller	|CC13-Fall-2014	
212	|Lisa Walker	|1	    |Ivana Teach	|CC17-Fall-2016	
212	|Lisa Walker	|2	    |James Smith	|CC18-Spring-2016	
213	|Paul Hall	|1	    |Ivana Teach	|CC10-Spring-2015	
213	|Paul Hall	|6	    |Michael Miller	|CC12-Spring-2015	
213	|Paul Hall	|2	    |James Smith	|CC18-Spring-2016	
214	|Nancy Allen	|6	    |Michael Miller	|CC12-Spring-2015	
214	|Nancy Allen	|1	    |Ivana Teach	|CC14-Fall-2015	
215	|Mark Young	|4	    |John Williams	|CC10-Fall-2016	
215	|Mark Young	|6	    |Michael Miller	|CC11-Spring-2016	
215	|Mark Young	|6	    |Michael Miller	|CC12-Summer-2012	
215	|Mark Young	|1	    |Ivana Teach	|CC14-Fall-2015	
215	|Mark Young	|1	    |Ivana Teach	|CC15-Spring-2015	
216	|Luis Hernandez	|6	    |Michael Miller	|CC10-Spring-2012	
216	|Luis Hernandez	|2	    |James Smith	|CC10-Spring-2013	
216	|Luis Hernandez	|4	    |John Williams	|CC10-Fall-2016	
216	|Luis Hernandez	|1	    |Ivana Teach	|CC11-Fall-2012	
216	|Luis Hernandez	|5	    |Patricia Jones	|CC12-Summer-2016	
216	|Luis Hernandez	|1	    |Ivana Teach	|CC15-Spring-2015	
NULL|NULL	|3	|Mary Johnson	|CC19-Fall-2016	
NULL|NULL	|4	|John Williams	|CC20-Summer-2016	    
NULL|NULL	|7	|Robert Brown   |NULL
NULL|NULL   |8	|Linda Davis	|NULL
217	|Donald King	 |NULL |NULL |NULL
218	|George Wright	 |NULL |NULL |NULL
	
# 10.

## Query
```sql
select c.name, c.course_code, p.prof_name, p.prof_id, count(concat(c.course_code,p.prof_id)) as "# times"
from course c
join semester_course sc on c.course_code = sc.course_code
join professor p on p.prof_id = sc.prof_id
group by p.prof_id , c.course_code
having count(concat(c.course_code,p.prof_id)) >= 2;
```

## Result

name|	course_code|	prof_name|	prof_id|	# times	
---|---|---|---|---
Data Structures|        	CC10|	Ivana Teach	|1	|2	
Air Quality Engineering|	CC15|	Ivana Teach	|1	|2	
Operating System Design|	CC12|	Michael Miller|	6|	2	

# 11.

## Query
```sql
select d.DEPT_NAME , count(sc.course_code) from 
department d 
left join professor p on p.dept_id = d.DEPT_ID
left join semester_course sc on sc.prof_id = p.prof_id
group by d.DEPT_ID
having count(sc.course_code) < 3;
```

## Result

DEPT_NAME	|count(sc.course_code)	
---|---
Arts	|0	
Electronics	|0	
Mechanics	|0	
