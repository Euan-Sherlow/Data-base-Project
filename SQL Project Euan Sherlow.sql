--CREATE SCRIPTS
CREATE TABLE research_group_tbl
(
	research_group_id VARCHAR(10),
	research_group_name VARCHAR(80),
	research_group_motto VARCHAR(200),
	PRIMARY KEY (research_group_id)
);

CREATE TABLE academic_tbl
(
	academic_id VARCHAR(10),
	academic_name VARCHAR(80),
	academic_employment DATE, 
	CHECK academic_employment > '15-12-1922' --unlikely be older than 100, so create a constraint
	academic_qualification VARCHAR(80),
	research_group_id VARCHAR(10),
	PRIMARY KEY(academic_id),
	FOREIGN KEY (research_group_id) REFERENCES research_group_tbl(research_group_id)
);

CREATE TABLE publication_tbl
(
	publication_id VARCHAR(10) NOT NULL,
	publication_date DATE NOT NULL,
	publication_title VARCHAR(80) NOT NULL,
	PRIMARY KEY (publication_id)
);

CREATE TABLE authoring_link_tbl
(
	academic_id VARCHAR(10),
	publication_id VARCHAR(10),
	PRIMARY KEY (academic_id, publication_id),
	FOREIGN KEY (academic_id) REFERENCES academic_tbl(academic_id),
	FOREIGN KEY (publication_id) REFERENCES publication_tbl(publication_id)
);
--INSERT SCRIPTS
INSERT INTO research_group_tbl VALUES ('R1', 'AI Group', 'What is research but a blind date with knowledge');
INSERT INTO research_group_tbl VALUES ('R2', 'IoT Group', 'Research is poking and prying with a purpose');
INSERT INTO research_group_tbl VALUES ('R3', 'Cyber Group', 'Research is to see what everybody else has seen, and to think what nobody else has thought');
INSERT INTO publication_tbl VALUES ('5028', '21-10-2020', 'Emerging AI');
INSERT INTO publication_tbl VALUES ('3069', '01-02-2021', 'Cloud security');
INSERT INTO publication_tbl VALUES ('9188', '11-12-2019', 'Machine Learning and its future');
INSERT INTO publication_tbl VALUES ('9099', '09-06-2022', 'AI in software engineering');
INSERT INTO publication_tbl VALUES ('1028', '29-09-2018', 'Cloud storage and its weaknesses');
INSERT INTO publication_tbl VALUES ('3320', '18-01-2020', 'Security against bots');
INSERT INTO publication_tbl VALUES ('2069', '30-05-2021', 'Machine Learning');
INSERT INTO publication_tbl VALUES ('1069', '28-07-2022', 'Advancements in hardware');
INSERT INTO academic_tbl VALUES ('1001', 'Jeff', '21-03-1975', 'Masters in Cyber Security', '5028','R1');
INSERT INTO academic_tbl VALUES ('1002', 'Bobb', '31-10-2001', 'Bachelors in Maths', '3069','R1');
INSERT INTO academic_tbl VALUES ('1003', 'Ella', '01-01-1964', 'PHD in Computer Science', '9188','R2');
INSERT INTO academic_tbl VALUES ('1004', 'Jennifer', '08-12-1996', 'Bachelors in Software engineering', '9099','R2');
INSERT INTO academic_tbl VALUES ('1005', 'Toby', '22-10-','12-04-1999', 'Bachelors in Maths', '1028','R3');
INSERT INTO academic_tbl VALUES ('1006', 'James', '30-03-1950', 'PHD in Computer Science', '3320','R3');
INSERT INTO academic_tbl VALUES ('1007', 'Bobb', '09-09-1991', 'Masters in chemistry', '2069','R3');
INSERT INTO academic_tbl VALUES ('1008', 'Glenn', '30-03-1950', 'PHD in Computer Science',NULL, 'R3');
INSERT INTO authoring_link_tbl VALUES ('1001', '5028');
INSERT INTO authoring_link_tbl VALUES ('1001', '3069');
INSERT INTO authoring_link_tbl VALUES ('1002', '3069');
INSERT INTO authoring_link_tbl VALUES ('1003', '9188');
INSERT INTO authoring_link_tbl VALUES ('1003', '9099');
INSERT INTO authoring_link_tbl VALUES ('1005', '1028');
INSERT INTO authoring_link_tbl VALUES ('1006', '3320');
INSERT INTO authoring_link_tbl VALUES ('1006', '2069');
INSERT INTO authoring_link_tbl VALUES ('1006', '1069');
INSERT INTO authoring_link_tbl VALUES ('1007', '2069');
INSERT INTO authoring_link_tbl VALUES ('1008', '3320');
INSERT INTO authoring_link_tbl VALUES ('1007', '1069');
COMMIT;

--SELECT SCRIPTS
--Q1
SELECT academic_name, academic_qualification, academic_employment 
	FROM academic_tbl;

--Q2
SELECT academic_name, research_group_name, research_group_motto
	FROM academic_tbl, research_group_tbl
	WHERE academic_tbl.research_group_id = research_group_tbl.research_group_id;

--Q3
SELECT research_group_name, research_group_motto, COUNT (research_group_name, research_group_motto) number_of_collabs
	FROM academic_tbl, research_group_tbl, authoring_link_tbl,
		(SELECT publication_id, COUNT(publication_id) count_count
		FROM authoring_link_tbl 
		GROUP BY publication_id) collaboration_tbl
	WHERE research_group_tbl.research_group_id = academic_tbl.research_group_id
	AND academic_tbl.academic_id = authoring_link_tbl.academic_id
	AND authoring_link_tbl.publication_id = collaboration_tbl.publication_id
	AND count_count > 1
	AND academic_tbl.academic_name = 'Ella'
	GROUP BY (academic_name, research_group_name, research_group_motto);

--Q4
SELECT academic_name, research_group_name, research_group_motto, COUNT (academic_name) number_of_collabs
	FROM academic_tbl, research_group_tbl, authoring_link_tbl,
		(SELECT publication_id, COUNT(publication_id) count_count
		FROM authoring_link_tbl 
		GROUP BY publication_id) collaboration_tbl
	WHERE research_group_tbl.research_group_id = academic_tbl.research_group_id
	AND academic_tbl.academic_id = authoring_link_tbl.academic_id
	AND authoring_link_tbl.publication_id = collaboration_tbl.publication_id
	AND count_count > 1
	ORDER BY number_of_collabs, DESC
	GROUP BY (research_group_name, research_group_motto);
	FETCH FIRST 2 ROWS ONLY;
	
COMMIT;

--DROP SCRIPTS
DROP authoring_link_tbl;
DROP academic_tbl;
DROP publication_tbl;
DROP research_group_tbl;
COMMIT;

