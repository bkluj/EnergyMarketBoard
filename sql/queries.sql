-- Preview the first 20 rows from the dataset.
SELECT
    *
FROM
    fact_power_system_load
LIMIT
    20;


-- Q1: What is the date range covered by the dataset?
-- Show the earliest datetime, latest datetime, and total number of records.


-- Q2: What are the average actual load and average forecasted load
-- for the entire dataset?


-- Q3: What were the highest and lowest actual load values?
-- Show the load value and the corresponding datetime.


-- Q4: What is the average actual load for each hour of the day?
-- Order the results from hour 0 to hour 23.


-- Q5: Which hours of the day have the highest average actual load?
-- Return the top 5 hours.


-- Q6: What is the average actual load for each weekday?
-- Sort the weekdays using weekday_number instead of alphabetical order.


-- Q7: Compare the average actual load between weekdays and weekends.
-- Show the number of observations, average actual load,
-- and average forecasted load for both groups.


-- Q8: How many forecasts were underforecasts, overforecasts, and exact forecasts?
-- Show the count and percentage of all observations for each forecast status.


-- Q9: What are the average absolute error and average percentage error
-- for each forecast status?


-- Q10: Which 10 timestamps had the largest absolute forecast errors?
-- Show datetime, actual load, forecasted load, forecast error,
-- and absolute error.


-- Q11: At which hours is the forecast least accurate?
-- Calculate the average absolute error for every hour
-- and return the 5 worst hours.


-- Q12: At which hours is the forecast most accurate?
-- Calculate the average absolute error for every hour
-- and return the 5 best hours.


-- Q13: Which weekdays have the highest average forecast error?
-- Show average signed error, average absolute error,
-- and average percentage error for every weekday.


-- Q14: Which records had actual load above the overall average actual load?
-- Show datetime, actual load, and forecasted load.
-- Use a subquery to calculate the overall average.


-- Q15: How many observations had an absolute forecast error
-- greater than the average absolute forecast error?
-- Use a subquery.


-- Q16: Divide actual load into three categories:
-- Low Load: below 18,000 MW
-- Medium Load: from 18,000 MW to 22,000 MW
-- High Load: above 22,000 MW
-- Show the number of observations and average forecast error
-- for each load category.


-- Q17: Compare forecast accuracy between weekdays and weekends.
-- Show MAE, MAPE, and RMSE for both groups.


-- Q18: What is the average actual load and average forecast error
-- for each date?
-- Order the results chronologically.


-- Q19: Which 5 dates had the highest average actual load?
-- Show the date, average actual load, and maximum actual load.


-- Q20: Which 5 dates had the highest average absolute forecast error?
-- Show the date, average absolute error, and maximum absolute error.