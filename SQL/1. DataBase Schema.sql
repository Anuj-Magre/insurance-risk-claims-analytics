
-- -----------------------------------------
-- Aegis Life Insurance Scehema 
-- ----------------------------------------



-- Create Database
CREATE SCHEMA IF NOT EXISTS aegis_database;
USE aegis_database;


-- ------------------------------------
-- Create Dimansion & Fact Table 
-- ------------------------------------

-- Create Customer_Master (Dimansion Table)

CREATE TABLE customer_master (
	Customer_ID varchar(50) primary key,
	Full_Name varchar(50) ,
	Age int,
	Gender enum('Male','Female','Other'),
	Marital_Status enum('Single','Married','Divorced'),
	Occupation enum('Salaried','Self-employed','Retired','Student'),
	Region enum('North','South','East','West','Central','North-East'),
	Smoking_Status enum('Yes','No'),
	Pre_Existing_Illness enum('Yes','No'),
	Risk_Score float,
	Date_Joined date
    );
    


-- Create Agent_Info (Dimansion Table)   

CREATE TABLE Agent_Info (
	Agent_ID varchar(50) primary key,
	Region enum('North','South','East','West','Central','North-East'),
	Join_Date date,
	Total_Policies_Sold INT,
	Lapsed_Policies  INT,
	Avg_Premium_Sold FLOAT,
	Fraud_Association INT
); 



-- Create Policy_Details (Fact Table)  

CREATE TABLE Policy_Details (
	Policy_ID varchar(50) primary key,
	Customer_ID varchar(50),    -- FK
	Product_Type enum('Term','Whole','Health','Vehicle','Property'),
	Coverage_Amount float,
	Annual_Premium float,
	Policy_Start_Date DATE,
	Policy_End_Date DATE,
	Agent_ID varchar(50),     -- FK
	Status ENUM('Active','Lapsed','Cancelled'),
	constraint policy_fk_customer foreign key (Customer_ID) references Customer_Master(Customer_ID),
	constraint policy_fk_agent foreign key (Agent_ID) references Agent_Info(Agent_ID)
);




-- Create Claim_History Table (Fact Table)

CREATE TABLE Claim_History (
	Claim_ID varchar(50) primary key,
	Policy_ID varchar(50),     -- FK
	Claim_Date date,
	Claim_Amount FLOAT,
	Claim_Status ENUM('Approved','Rejected','Pending'),
	Claim_Type ENUM('Hospital','Accident','Death','Theft','Other'),
	Fraud_Flag ENUM('Yes','No'),
	Days_To_Process INT,
	constraint claim_fk_policy foreign key (Policy_ID) references Policy_Details(Policy_ID)
);



-- Create Customer_Feedback_Surveys Table (Fact Table)

/* Feedback table contains non-null customer IDs that do not exist in customer_master table 
 so we use this approach:
Create a staging table without foreign key.
Load all 1000 feedback rows into staging.
Insert into final table and convert unmatched customer IDs to NULL
*/

CREATE TABLE customer_feedback_staging (
    Feedback_ID VARCHAR(50),
    Customer_ID VARCHAR(50),
    Date_Submitted DATE,
    Feedback_Text VARCHAR(255),
    Satisfaction_Score INT,
    Contacted_Agent ENUM('Yes','No'),
    Referred_Claim ENUM('Yes','No')
);


CREATE TABLE customer_feedback_surveys (
    Feedback_ID VARCHAR(50) PRIMARY KEY,
    Customer_ID VARCHAR(50) NULL,
    Date_Submitted DATE,
    Feedback_Text VARCHAR(255),
    Satisfaction_Score INT,
    Contacted_Agent ENUM('Yes','No'),
    Referred_Claim ENUM('Yes','No'),
    Unmatched_Customer_Flag ENUM('Yes','No'),
    CONSTRAINT feedback_fk_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES customer_master(Customer_ID)
);


INSERT INTO customer_feedback_surveys
SELECT
    f.Feedback_ID,
    CASE
        WHEN c.Customer_ID IS NULL THEN NULL
        ELSE f.Customer_ID
    END AS Customer_ID,
    f.Date_Submitted,
    f.Feedback_Text,
    f.Satisfaction_Score,
    f.Contacted_Agent,
    f.Referred_Claim,
    CASE
        WHEN c.Customer_ID IS NULL THEN 'Yes'
        ELSE 'No'
    END AS Unmatched_Customer_Flag
FROM customer_feedback_staging f
LEFT JOIN customer_master c
ON f.Customer_ID = c.Customer_ID;


-- End Schema