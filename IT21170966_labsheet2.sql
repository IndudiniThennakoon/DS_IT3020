-- (A)


CREATE TYPE emp_t AS OBJECT(
empNo CHAR(6),
firstName VARCHAR2(12),
lastName VARCHAR2(15),
workdept REF dept_t,
sex CHAR(1),
birthDate DATE,
salary NUMBER(8,2)
) 
/

CREATE TYPE dept_t AS OBJECT(
deptNo CHAR(3),
deptName VARCHAR2(36),
mgrno REF emp_t,
admrdept REF dept_t
) 
/


-- (B)

CREATE TABLE ORDEPT OF dept_t(
    CONSTRAINT ordept_pk PRIMARY KEY(deptNo)
)
/

CREATE TABLE OREMP OF emp_t(
    CONSTRAINT oremp_pk PRIMARY KEY(empNo),
    CONSTRAINT oremp_workdept_fk FOREIGN KEY(workdept) REFERENCES ORDEPT
)
/

ALTER TABLE ORDEPT ADD CONSTRAINT ordept_mgrno_fk FOREIGN KEY(mgrno) REFERENCES OREMP;
ALTER TABLE ORDEPT ADD CONSTRAINT ordept_admrdept_fk FOREIGN KEY(admrdept) REFERENCES ORDEPT;

-- (C)

INSERT INTO OREMP VALUES(emp_t('000010', 'CHRISTINE', 'HASS', NULL, 'F', '14-AUG-1953', 72750));
INSERT INTO OREMP VALUES(emp_t('000020', 'MICHAEL', 'THOMPSON', NULL, 'M', '02-FEB-1968', 61250));
INSERT INTO OREMP VALUES(emp_t('000030', 'SALLY', 'KWAN', NULL, 'F', '11-MAY-1971', 58250));
INSERT INTO OREMP VALUES(emp_t('000060', 'IRVING', 'STERN', NULL, 'M', '07-JUL-1965', 55555));
INSERT INTO OREMP VALUES(emp_t('000070', 'EVA', 'PULAKSI', NULL, 'F', '26-MAY-1973', 56170));
INSERT INTO OREMP VALUES(emp_t('000050', 'JOHN', 'GEYER', NULL, 'M', '15-SEP-1955', 60175));
INSERT INTO OREMP VALUES(emp_t('000090', 'EILEEN', 'HENDERSON', NULL, 'F', '15-MAY-1961', 49750));
INSERT INTO OREMP VALUES(emp_t('000100', 'THEODORE', 'SPENSER', NULL, 'M', '18-AUG-1976', 46150));


INSERT INTO ORDEPT VALUES (dept_t('A00', 'SPIFFY COMPUTER SERVICE DIV.', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000010'), NULL));
INSERT INTO ORDEPT VALUES (dept_t('B01', 'PLANNING', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000020'), NULL));
INSERT INTO ORDEPT VALUES (dept_t('C01', 'INFORMATION CENTER', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000030'), NULL));
INSERT INTO ORDEPT VALUES (dept_t('D01', 'DEVELOPMENT CENTER', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000060'), NULL));


UPDATE OREMP e
SET e.workdept = (SELECT REF(d) FROM ORDEPT d WHERE D.deptNo = 'A00')
WHERE e.empNo = '000010'
/
UPDATE oremp e
SET e.workDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'B01')
WHERE e.empNo = '000020'
/
UPDATE oremp e
SET e.workDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'C01')
WHERE e.empNo = '000030'
/
UPDATE oremp e
SET e.workDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'D01')
WHERE e.empNo = '000060'
/
UPDATE oremp e
SET e.workDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'D01')
WHERE e.empNo = '000070'
/
UPDATE oremp e
SET e.workDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'C01')
WHERE e.empNo = '000050'
/
UPDATE oremp e
SET e.workDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'B01')
WHERE e.empNo = '000090'
/
UPDATE oremp e
SET e.workDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'B01')
WHERE e.empNo = '000100'
/



UPDATE ORDEPT d
SET d.admrDept = (SELECT REF(d) from ORDEPT d where d.deptNo='A00')
WHERE d.deptNo = 'A00'
/
UPDATE ORDEPT d
SET d.admrDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo='A00')
WHERE d.deptNo = 'B01'
/
UPDATE ORDEPT d
SET d.admrDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo='A00')
WHERE d.deptNo = 'C01'
/
UPDATE ORDEPT d
SET d.admrDept = (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo='C01')
WHERE d.deptNo = 'D01'
/

-- (2) (a)

SELECT d.deptName , d.mgrno.lastName
FROM ORDEPT d
/

-- (2) (b)

SELECT e.empNo, e.lastName, e.workdept.deptName
FROM OREMP e
/

-- (2) (c)

SELECT d.deptNo, d.deptName, d.admrdept.deptName 
FROM ORDEPT d
/

-- (2) (d)

SELECT d.deptNo, d.deptName, d.admrdept.deptName AS admrDeptName,, d.admrdept.mgrno.lastName AS mgrLastName
FROM ORDEPT d
/

-- (2) (e)

SELECT e.empNo,e.firstName,e.lastName,e.salary,e.workdept.mgrno.lastName,e.workdept.mgrno.salary
FROM OREMP e
/

-- (2) (f)

SELECT 
    d.deptNo,
    d.deptName,
    (SELECT AVG(e.salary) FROM OREMP e WHERE DEREF(e.workdept).deptNo = d.deptNo AND e.sex = 'M') AS avg_salary_men,
    (SELECT AVG(e.salary) FROM OREMP e WHERE DEREF(e.workdept).deptNo = d.deptNo AND e.sex = 'F') AS avg_salary_women
FROM 
    ORDEPT d
/





