-- *******************************
-- Aegis Life Insurance Analysis 
-- *******************************


-- ---------------------------
-- Data Overview
-- ---------------------------

select * from customer_master;
select * from agent_info;
select * from claim_history;
select * from customer_feedback_surveys;
select * from policy_details;






-- -----------------
-- Row Counts
-- -----------------

SELECT COUNT(*) FROM customer_master;
SELECT COUNT(*) FROM agent_info;
SELECT COUNT(*) FROM policy_details;
SELECT COUNT(*) FROM claim_history;
SELECT COUNT(*) FROM customer_feedback_surveys;


-- ------------------------------------
-- CREATE VIEW PREMIUM COLLECTED 
-- ------------------------------------

CREATE VIEW policy_detail AS (
SELECT
	*,
	ROUND(
		DATEDIFF(policy_end_date, policy_start_date) / 365,
		2) AS duration_years,
	ROUND(
		annual_premium *
		(DATEDIFF(policy_end_date, policy_start_date) / 365),
		2) AS premium_collected
    FROM policy_details);


-- ----------------------------
-- CREATE VIEW APPROVED CLAIMS
-- ----------------------------

CREATE VIEW approved_claims AS (
SELECT
	*
FROM claim_history
WHERE claim_status = 'Approved');

-- ----------------------------
-- EXECUTIVE KPI QUERIES
-- ----------------------------



-- ************************
-- Total Premium Collected
-- ************************

SELECT
    ROUND(SUM(premium_collected),2) AS total_premium_collected
FROM policy_detail;


-- ******************
-- Total Claims Paid
-- ******************

SELECT
	ROUND(
		SUM(Claim_Amount),2) AS total_claim_amount
FROM approved_claims;



-- *********************
-- Claim Approval Rate
-- *********************

SELECT
	ROUND( 
		(SUM(CASE WHEN claim_status = 'Approved' THEN 1 ELSE 0 END)
         / COUNT(*)) * 100,
		2) AS claim_approval_rate
FROM claim_history;



-- *************
-- Fraud Ratio
-- *************

SELECT
	ROUND( 
		(SUM(CASE WHEN Fraud_Flag = 'Yes' THEN 1 ELSE 0 END)
         / COUNT(*)) *100,
	  2) AS fraud_ratio
FROM claim_history;



-- ***********
-- Loss Ratio 
-- ***********

SELECT
    ROUND(
		(SELECT 
			SUM(claim_amount)
		FROM approved_claims) /
        (SELECT
			SUM(premium_collected) 
		FROM policy_detail)*100,
	2) AS loss_ratio;



-- ---------------------------
-- REGIONAL RISK ANALYTICS
-- ---------------------------


-- ***********************
-- Region-Wise Loss Ratio
-- ***********************


WITH premium_data AS(
	SELECT
		c.region,
		ROUND(
            SUM(premium_collected),
            2) AS total_premium_collected
    FROM policy_detail p
    JOIN customer_master c
        ON p.customer_id = c.customer_id
    GROUP BY c.region
),

claim_data AS (
	SELECT
		c.region,
        ROUND(
            SUM(ch.claim_amount),
            2) AS total_claims_paid
    FROM approved_claims ch
    JOIN policy_detail p
        ON ch.policy_id = p.policy_id
    JOIN customer_master c
        ON p.customer_id = c.customer_id
    GROUP BY c.region
)

SELECT
    p.region,
    p.total_premium_collected,
    c.total_claims_paid,
    ROUND(
        (c.total_claims_paid / p.total_premium_collected) * 100,
        2
    ) AS loss_ratio_percent
FROM premium_data p
JOIN claim_data c
    ON p.region = c.region
ORDER BY loss_ratio_percent DESC;



-- ********************
-- High Fraud Regions
-- ********************

SELECT 
	c.region,
    COUNT(ch.fraud_flag) as total_claims,
    SUM(CASE WHEN ch.fraud_flag ='Yes' THEN 1 ELSE 0 END) AS fraud_claims,
    ROUND(
		(SUM(CASE WHEN ch.Fraud_Flag = 'Yes' THEN 1 ELSE 0 END)  /
        COUNT(ch.fraud_flag)) *100 ,
	  2) AS fraud_ratio
      
FROM claim_history ch 
JOIN policy_details p
	ON ch.policy_id = p.policy_id
JOIN customer_master c
	ON c.customer_id = p.customer_id
GROUP BY c.region
ORDER BY 4 DESC;



-- -----------------------
-- PRODUCT RISK ANALYTICS
-- -----------------------



-- ****************************
-- Product-Wise Claim Exposure
-- ****************************

SELECT 
	p.product_type,
	COUNT(ch.claim_id) AS total_claims,
    ROUND(AVG(ch.claim_amount),2) AS avg_claim_amount,
    ROUND(SUM(ch.claim_amount),2) AS total_claim_amount
FROM policy_details p
JOIN claim_history ch
	ON ch.policy_id = p.policy_id
GROUP BY p.product_type
ORDER BY 4 DESC;



-- **********************
-- Product Profitability
-- **********************

WITH premium_data AS(
	SELECT
		product_type,
		ROUND(
            SUM(premium_collected),
            2) AS total_premium_collected
    FROM policy_detail p
    GROUP BY product_type
),

claim_data AS (
	SELECT
		p.product_type,
        ROUND(
            SUM(ch.claim_amount),
            2) AS total_claims_paid
    FROM approved_claims ch
    JOIN policy_detail p
        ON ch.policy_id = p.policy_id
    GROUP BY p.product_type
)

SELECT
    p.product_type,
    p.total_premium_collected,
    c.total_claims_paid,
    ROUND(
        (c.total_claims_paid / p.total_premium_collected) * 100,
        2
    ) AS loss_ratio_percent
FROM premium_data p
JOIN claim_data c
    ON p.product_type = c.product_type
ORDER BY loss_ratio_percent DESC;




-- ------------------------
-- CUSTOMER RISK ANALYTICS
-- ------------------------


-- **********************
-- High Risk Customers
-- **********************

SELECT
	customer_id,
    full_name,
    region,
    smoking_status,
    pre_existing_illness,
    risk_score
FROM customer_master
WHERE risk_score > 0.75
ORDER BY risk_score DESC;



-- ****************************
-- Smoker vs Non-Smoker Claims
-- ****************************

SELECT
	cm.smoking_status,
    COUNT(ch.claim_id) AS total_claims,
    ROUND(AVG(ch.claim_amount),2) AS avg_claim_amount    
FROM policy_details pd
JOIN customer_master cm
	ON cm.customer_id = pd.customer_id
JOIN claim_history ch
	ON ch.policy_id = pd.policy_id
GROUP BY cm.smoking_status;



-- ********************************
-- Top 5 Customers by Claim Amount
-- ********************************

SELECT *
FROM (
	SELECT 
		cm.customer_id,
		cm.full_name,
		ROUND(SUM(ch.claim_amount),2) AS total_claim_amount,
		RANK() OVER(ORDER BY SUM(ch.claim_amount) DESC) AS customer_rank
	FROM customer_master cm
	JOIN policy_details pd
		ON cm.customer_id = pd.customer_id
	JOIN claim_history ch
		ON ch.policy_id = pd.policy_id
	GROUP BY 1,2
		) AS ranked_customers
WHERE customer_rank <=5;



-- ****************************
-- Customer Risk Segmentation
-- ****************************


SELECT 
	customer_id,
    full_name,
    risk_score,
    CASE
        WHEN risk_score >= 0.80 THEN 'Critical Risk'
        WHEN risk_score >= 0.60 THEN 'High Risk'
        WHEN risk_score >= 0.40 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS risk_segment
FROM customer_master;



-- ***************************
-- segment-wise analysis
-- ***************************

WITH segment_customer AS (
SELECT 
    CASE
        WHEN risk_score >= 0.80 THEN 'Critical Risk'
        WHEN risk_score >= 0.60 THEN 'High Risk'
        WHEN risk_score >= 0.40 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS risk_segment
FROM customer_master )

SELECT 
	risk_segment,
    COUNT(risk_segment) as number_of_customers
FROM segment_customer
GROUP BY risk_segment;






-- --------------------
-- AGENT INTELLIGENCE
-- --------------------


-- ************************
-- Fraud-Associated Agents
-- ************************

SELECT 
	agent_id,
    total_policies_sold,
    fraud_association,
    ROUND(
		(fraud_association  / total_policies_sold)*100 ,2) AS fraud_ratio    
FROM agent_info
ORDER BY 4 DESC;


-- *********************
-- Agent Productivity
-- *********************

SELECT
	agent_id,
	total_policies_sold,
    avg_premium_sold,
    lapsed_policies,
    ROUND(
		(lapsed_policies / total_policies_sold) * 100 ,2) AS lapse_ratio
FROM agent_info
ORDER BY 2 DESC;





-- ----------------------------
-- CLAIM PROCESSING ANALYSIS
-- ----------------------------


-- ******************************
-- Average Claim Processing Time
-- ******************************

SELECT
	ROUND(AVG(DAYS_TO_PROCESS),2) AS avg_processing_days   
FROM approved_claims;


-- ********************************
-- Processing Time by Claim Status
-- ********************************

SELECT 
	claim_status,
    COUNT(*) AS total_claims,
    ROUND(AVG(days_to_process),2) AS avg_processing_days 
FROM claim_history
GROUP BY claim_status
ORDER BY 3 DESC;



-- ********************************
-- Claim Type Operational Analysis
-- ********************************

SELECT
    claim_type,
    COUNT(*) AS total_claims,
    SUM(
        CASE WHEN claim_status = 'Approved' THEN 1 ELSE 0 END
		) AS total_approved_claims,
    ROUND(AVG(days_to_process), 2) AS avg_claims_processing_days,
    ROUND(
        AVG(
            CASE WHEN claim_status = 'Approved' THEN days_to_process ELSE NULL END
			), 2) AS avg_approved_claim_days_to_process,
	ROUND(AVG(claim_amount), 2) AS avg_claim_amount,
    ROUND(
        AVG(
            CASE WHEN claim_status = 'Approved' THEN claim_amount ELSE NULL END
			), 2) AS avg_approved_claim_amount
FROM claim_history
GROUP BY claim_type
ORDER BY total_approved_claims DESC;



-- --------------------------
-- FRAUD PROCESSING ANALYSIS
-- --------------------------


-- ****************************************        
-- Fraud vs Non-Fraud Operational Analysis    
-- ****************************************

SELECT
	fraud_flag,
    COUNT(*) AS total_claims,
    ROUND(AVG(days_to_process),2) AS avg_processing_days,
    ROUND(AVG(claim_amount),2) AS avg_claim_amount
FROM claim_history
GROUP BY fraud_flag
ORDER BY 3 DESC;




-- ----------------------------
-- PREMIUM ADEQUACY ANALYSIS
-- ----------------------------


-- ***************************************
-- -- Customer Premium vs Claim Exposure
-- ***************************************


SELECT
	cm.customer_id,
    cm.full_name,
    ROUND(SUM(pd.premium_collected),2) AS total_premium_paid,
    ROUND(SUM(ch.claim_amount),2) AS total_claim_amount,
    ROUND(
		SUM(ch.claim_amount) - SUM(pd.premium_collected),
        2
    ) AS underwriting_loss
FROM policy_detail pd
JOIN customer_master cm
	ON cm.customer_id = pd.customer_id
JOIN approved_claims ch
	ON pd.policy_id = ch.policy_id
GROUP BY 1,2
ORDER BY 5 DESC
LIMIT 10;
    
    
    
-- ---------------------------------
-- Agent-wise Policy Lapse Analysis
-- ---------------------------------

SELECT
    agent_id,
    total_policies_sold,
    lapsed_policies,
    ROUND(
        (lapsed_policies / total_policies_sold) * 100,
        2
    ) AS lapse_rate
FROM agent_info
ORDER BY 3 DESC
LIMIT 10;    



-- -----------------------------------------
-- Top 3 Agents Per Region by Policies_sold
-- -----------------------------------------

SELECT 
	region,
    agent_id,
    total_policies_sold
FROM
	(SELECT 
		region,
		agent_id,
        SUM(total_policies_sold) AS 'total_policies_sold',
        RANK() OVER(PARTITION BY region ORDER BY SUM(total_policies_sold) DESC) rn
	  FROM agent_info
      GROUP BY 1,2
	)t
WHERE rn<=3;



-- --------------------------------
-- customer lifetime premium value
-- --------------------------------


SELECT
    customer_id,
    ROUND(
        SUM(duration_years),
        2 ) AS policy_duration_years,
    ROUND(SUM(annual_premium),2) AS annual_premium,
    ROUND(SUM(
			(duration_years) * (annual_premium)),
	2) AS estimated_total_premium_paid
FROM policy_detail
GROUP BY customer_id;




-- -----------------
-- Analysis By Time
-- -----------------

-- **************************
-- yearly customer join
-- **************************


SELECT
	YEAR(date_joined) AS year,
    COUNT(*) AS customer_joined
FROM customer_master
GROUP BY YEAR(date_joined)
ORDER BY 1;


-- **********************
-- yearly joining growth
-- **********************


WITH YEARLY_CUSTOMER AS 
(
SELECT
	YEAR(date_joined) AS year,
    COUNT(*) AS customer_joined
FROM customer_master
group by 1
)

SELECT 
	year,
    customer_joined AS yearly_customer_joined,
    SUM(customer_joined) OVER( ORDER BY year) AS total_customer,
    ROUND(
    (customer_joined - LAG(customer_joined) OVER(ORDER BY year))/
    LAG(customer_joined) OVER(ORDER BY year) *100,
    2) AS yearly_joining_growth_pct
FROM YEARLY_CUSTOMER;



-- ********************
-- yearly claims
-- *******************


SELECT
	YEAR(claim_Date) AS year,
    COUNT(*) AS total_claims,
    SUM(
		CASE WHEN claim_status ='Approved'
			THEN 1 ELSE 0 END
		) AS total_approved_claims
FROM claim_history
GROUP BY YEAR(claim_date)
ORDER BY 1;




-- ***********************
-- yearly policy analysis
-- ***********************

SELECT
	YEAR(policy_start_date) AS year,
    status,
    COUNT(*) AS total_policies
FROM policy_details
GROUP BY 1,2
ORDER BY 1,2;


-- **************************
-- fraud analysis by year
-- **************************


WITH fraud_claims AS
(
SELECT
	YEAR(claim_date) AS year,
	COUNT(*)OVER(PARTITION BY YEAR(CLAIM_DATE) ORDER BY YEAR(CLAIM_DATE)) AS total_claims,
	claim_type,
    claim_status,
    fraud_flag
FROM claim_history
)

SELECT
	year,
    total_claims,
    SUM(
		CASE WHEN fraud_flag ='Yes' THEN 1 ELSE 0 END
        ) AS total_fraud_claims,
	SUM(
		CASE WHEN fraud_flag ='No' THEN 1 ELSE 0 END
        ) AS total_Non_fraud_claims,
	ROUND((
    SUM(
		CASE WHEN fraud_flag ='Yes' THEN 1 ELSE 0 END)
         / total_claims) *100,
        2) AS fraud_rate
FROM fraud_claims
GROUP BY 1;




-- *********************
--  Yearly agent joined
-- *********************

SELECT
	YEAR(JOIN_DATE),
    COUNT(*) AS agent_joined
FROM agent_info 
GROUP BY YEAR(join_date)
ORDER BY 1;
