create table finance(
	id	INT PRIMARY KEY,	
	address_state VARCHAR(50),	
	application_type VARCHAR(50),	
	emp_length	VARCHAR(50),	
	emp_title	VARCHAR(200)	,
	grade	VARCHAR(50),	
	home_ownership	VARCHAR(50),	
	issue_date	DATE,	
	last_credit_pull_date	DATE,	
	last_payment_date	DATE,	
	loan_status	VARCHAR(50),	
	next_payment_date	DATE,	
	member_id	VARCHAR(50),	
	purpose	VARCHAR(50)  ,	
	sub_grade	VARCHAR(50),	
	term	VARCHAR(50),	
	verification_status	VARCHAR(50),	
	annual_income	FLOAT,	
	dti	FLOAT,	
	installment	FLOAT,	
	int_rate	FLOAT,	
	loan_amount	INTEGER,	
	total_acc	INTEGER,	
	total_payment	INTEGER 	
);
DROP TABLE FINANCE ;

SELECT * FROM FINANCE;

SELECT COUNT(*)  AS TOTAL_APPLICATIONS
FROM FINANCE;

-- MOM Application 
SELECT COUNT(id) as MTD_APPLICATION 
FROM finance 
WHERE EXTRACT(MONTH from issue_date)=12-- DECEMBER 
AND EXTRACT (YEAR FROM issue_date) = 2021


--PMTD APPLICATION
SELECT COUNT(id) as PMTD_APPLICATION 
FROM finance 
WHERE EXTRACT(MONTH from issue_date)=11-- NOVEMBER 
AND EXTRACT (YEAR FROM issue_date) = 2021;

-- TOTAL FUNDED AMOUNT

SELECT SUM(loan_amount) as total_funded 
from finance 
WHERE EXTRACT(MONTH from issue_date)=12-- DECEMBER 
AND EXTRACT (YEAR FROM issue_date) = 2021

SELECT SUM(loan_amount) as total_funded 
from finance 
WHERE EXTRACT(MONTH from issue_date)=11-- NOVEMBER 
AND EXTRACT (YEAR FROM issue_date) = 2021

-- TOTAL AMOUNT 

SELECT SUM(total_payment) AS BANK_LOAN_DATA
FROM FINANCE ;

SELECT SUM(total_payment) AS  mtd_BANK_LOAN_DATA
FROM FINANCE
WHERE EXTRACT (MONTH FROM issue_date) = 12 
AND  EXTRACT (YEAR  fROM issue_date )= 2021;

SELECT SUM(total_payment) AS  PMTD_BANK_LOAN_DATA
FROM FINANCE
WHERE EXTRACT (MONTH FROM issue_date) = 11 
AND  EXTRACT (YEAR  fROM issue_date )= 2021;

--AVG INTEREST RATE
SELECT concat(round(( AVG(int_rate)*100)::numeric,2 ),' %') as AVG_INT_RATE
FROM finance;

--MTD_AVG INTEREST RATE
SELECT concat(round(( AVG(int_rate)*100)::numeric,2 ),' %') as MTD_AVG_IN_RATE
FROM finance
WHERE EXTRACT (MONTH FROM issue_date) = 12 
AND  EXTRACT (YEAR  fROM issue_date )= 2021;
--PMTD_AVG INTEREST RATE
SELECT concat(round(( AVG(int_rate)*100)::numeric,2 ),' %') as MTD_AVG_IN_RATE
FROM finance
WHERE EXTRACT (MONTH FROM issue_date) = 11 
AND  EXTRACT (YEAR  fROM issue_date )= 2021;

--AVG DEBT TO INCOME RATE

SELECT  CONCAT(ROUND(( AVG(dti)*100)::NUMERIC,2),' %') AS DEBT_RATE FROM FINANCE;

--MTD AVG DEBT TO INCOME RATE

SELECT concat(round(( AVG(dti)*100)::numeric,2 ),' %') as MTD_AVG_DTI
FROM finance
WHERE EXTRACT (MONTH FROM issue_date) = 12 
AND  EXTRACT (YEAR  fROM issue_date )= 2021;

--PMTD AVG DEBT TO INCOME RATE

SELECT concat(round(( AVG(dti)*100)::numeric,2 ),' %') as PMTD_AVG_DTI
FROM finance
WHERE EXTRACT (MONTH FROM issue_date) = 11 
AND  EXTRACT (YEAR  fROM issue_date )= 2021;

-- GOOD LOAN AND BAD LOAN 
SELECT LOAN_STATUS FROM FINANCE;

SELECT 
	(COUNT( CASE WHEN loan_status ='Fully Paid' or loan_status ='Currrent'
		THEN id end)*100)
	/
	count(id) as good_loan_percentage
	from finance;

-- find good loan application 
SELECT COUNT(ID) AS APPLICATION 
FROM FINANCE
WHERE loan_status ='Fully Paid' or loan_status='Current';

-- GOOD LOAN FUNDED AMOUNT
SELECT SUM(total_payment) AS APPLICATION_funded
FROM FINANCE
WHERE loan_status ='Fully Paid' or loan_status='Current';

-- GOOD LOAN RECEIVED AMOUNT
SELECT SUM(loan_amount) AS APPLICATION_funded
FROM FINANCE
WHERE loan_status ='Fully Paid' or loan_status='Current';

--BAD LOAN PARCENTAGE
SELECT 
	(COUNT( CASE
			WHEN loan_status='Charged Off' then id end)*100.0)
		/
	COUNT(ID) AS BAD_LOAN_PERCENTAGE
FROM FINANCE;

--TOTAL bad APPLICATION 
SELECT 
	COUNT(ID) AS bad_loan_application
FROM FINANCE
WHERE loan_status ='Charged Off'

--TOTAL APPLICATION FUNDED
select sum(loan_amount) as bad_loan_funded
from finance
where loan_status ='Charged Off'

--TOTAl bad_loan recovery
select sum(total_payment) as bad_loan_recovery
from finance
where loan_status ='Charged Off'

--LOAN STATUS GRADE VIEW 
SELECT loan_status,
	 COUNT(ID) AS TOTAL_APPLICATION,
	 SUM(total_payment) as total_amount_received,
	 sum(loan_amount) as total_funded_amount,
	 concat(round(avg(int_rate*100)::numeric,2),' %' )as interest_rate,
	 concat(round (avg(dti*100):: numeric,2),' %') as DTI
	 from finance
group by loan_status;

--LOAN MTD STATUS GRADE VIEW 

SELECT loan_status,
	 COUNT(ID) AS TOTAL_APPLICATION,
	 SUM(total_payment) as MTD_total_amount_received,
	 sum(loan_amount) as MTD_total_funded_amount
	 FROM finance
where extract (month from issue_date) =12
group by loan_status;

--LOAN MOM STATUS GRADE VIEW 

SELECT loan_status,
	 COUNT(ID) AS TOTAL_APPLICATION,
	 SUM(total_payment) as MOM_total_amount_received,
	 sum(loan_amount) as MOM_total_funded_amount
	 FROM finance
where extract (month from issue_date) =11
group by loan_status;

-- 	MONTHLY TRAND BY ISSUE DATE

SELECT 
	EXTRACT ( month from issue_date) as months,
	TO_CHAR (issue_date,'MONTH') AS MONTHNAME,
	COUNT(ID) AS Total_application,
	SUM (total_payment) as total_Amount_Received ,
	SUM (loan_amount) as total_amoun_funded
FROM FINANCE
GROUP BY months,MONTHNAME
ORDER BY months;

-- REGIONAL ANALYSIS BY STATES WISE FUNDED 

SELECT 
	address_state,
	COUNT(ID) AS Total_application,
	SUM (total_payment) as total_Amount_Received ,
	SUM (loan_amount) as total_amoun_funded
FROM FINANCE
GROUP BY address_state
ORDER BY total_amoun_funded DESC;

-- loan term analysis 
SELECT  
	TERM AS LOAN_TERM,
	COUNT(ID) AS Total_application,
	SUM (total_payment) as total_Amount_Received ,
	SUM (loan_amount) as total_amoun_funded
	FROM FINANCE
GROUP BY LOAN_TERM
order BY LOAN_TERM;


select emp_length AS emp_services,
	COUNT(ID) AS Total_application,
	SUM (total_payment) as total_Amount_Received ,
	SUM (loan_amount) as total_amoun_funded
	FROM FINANCE
GROUP BY emp_services
order BY emp_services desc;
-- analysis the reason behind taking loan
select purpose AS loan_reason,
	COUNT(ID) AS Total_application,
	SUM (total_payment) as total_Amount_Received ,
	SUM (loan_amount) as total_amoun_funded
	FROM FINANCE
GROUP BY loan_reason
order BY Total_application desc;

select home_ownership  ,
	COUNT(ID) AS Total_application,
	SUM (total_payment) as total_Amount_Received ,
	SUM (loan_amount) as total_amoun_funded
	FROM FINANCE
GROUP BY home_ownership
order BY Total_application desc;

