INSERT INTO EMPLOYEE VALUES(
	'123456789',
    'John',
    'Smith',
    '1965-01-09',
    '731 Fondren, Houston, TX',
    'M',
    30000,
    5
);

INSERT INTO DEPARTMENT VALUES(
	5,
    'Research',
    '123456789',
    '1988-05-22'
);

INSERT INTO employee VALUES(
	'987654321',
    'Jennifer',
    'Wallace',
    '1941-06-20',
    '291 Berry, Bellaire, TX',
    'F',
    43000,
    5
);
INSERT INTO employee VALUES(
	'888665555',
    'James',
    'Borg',
    '1937-11-10',
    '450 Stone, Houston, TX',
    'M',
    55000,
    5
);
INSERT INTO department VALUES(
	4,
    'Administration',
    '987654321',
    '1995-01-01'
);

INSERT INTO department VALUES(
	1,
    'Headquarters',
    '888665555',
    '1981-06-19'
);

UPDATE employee set dno = 4 WHERE ssn = '987654321';
UPDATE employee set dno = 1 where ssn = '888665555';

insert into project VALUES(
	10,
    'Computerization',
    'Stafford',
    4
);
insert into project VALUES(
	20,
    'Reorganization',
    'Houston',
    1
);
insert into project VALUES(
	30,
    'Newbenefits',
    'Stafford',
    4
);

INSERT INTO employee VALUES(
	'999887777',
    'Alicia',
    'Zelaya',
    '1968-01-19',
    '3321 Castle, Spring, TX',
    'F',
    25000,
    4
);