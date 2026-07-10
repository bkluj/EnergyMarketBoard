SELECT
    datetime
FROM
    fact_power_system_load
LIMIT
    20;


-- Q1: What is the date range covered by the dataset?
-- Show the earliest datetime, latest datetime, and total number of records.
SELECT
    MIN(datetime) AS earliest_datetime,
    MAX(datetime) AS latest_datetime,
    COUNT(*) AS total_records
FROM
    fact_power_system_load;


-- Q2: What are the average actual load and average forecasted load
-- for the entire dataset?
SELECT
    ROUND(AVG(actual_load_mw)::NUMERIC, 2) AS average_actual_load_mw,
    ROUND(AVG(forecasted_load_mw)::NUMERIC, 2) AS average_forecasted_load_mw
FROM
    fact_power_system_load;


-- Q3: What were the highest and lowest actual load values?
-- Show the load value and the corresponding datetime.
(
    SELECT
        'Highest Load' AS load_type,
        datetime,
        actual_load_mw
    FROM
        fact_power_system_load
    ORDER BY
        actual_load_mw DESC,
        datetime
    LIMIT
        1
)

UNION ALL

(
    SELECT
        'Lowest Load' AS load_type,
        datetime,
        actual_load_mw
    FROM
        fact_power_system_load
    ORDER BY
        actual_load_mw ASC,
        datetime
    LIMIT
        1
);


-- Q4: What is the average actual load for each hour of the day?
-- Order the results from hour 0 to hour 23.
SELECT
    hour,
    ROUND(AVG(actual_load_mw)::NUMERIC, 2) AS average_actual_load_mw
FROM
    fact_power_system_load
GROUP BY
    hour
ORDER BY
    hour;


-- Q5: Which hours of the day have the highest average actual load?
-- Return the top 5 hours.
SELECT
    hour,
    ROUND(AVG(actual_load_mw)::NUMERIC, 2) AS average_actual_load_mw
FROM
    fact_power_system_load
GROUP BY
    hour
ORDER BY
    average_actual_load_mw DESC
LIMIT
    5;


-- Q6: What is the average actual load for each weekday?
-- Sort the weekdays using weekday_number instead of alphabetical order.
SELECT
    weekday_number,
    weekday,
    ROUND(AVG(actual_load_mw)::NUMERIC, 2) AS average_actual_load_mw
FROM
    fact_power_system_load
GROUP BY
    weekday_number,
    weekday
ORDER BY
    weekday_number;


-- Q7: Compare the average actual load between weekdays and weekends.
-- Show the number of observations, average actual load,
-- and average forecasted load for both groups.
SELECT
    CASE
        WHEN is_weekend = TRUE THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_observations,
    ROUND(AVG(actual_load_mw)::NUMERIC, 2) AS average_actual_load_mw,
    ROUND(AVG(forecasted_load_mw)::NUMERIC, 2) AS average_forecasted_load_mw
FROM
    fact_power_system_load
GROUP BY
    is_weekend
ORDER BY
    is_weekend;


-- Q8: How many forecasts were underforecasts, overforecasts,
-- and exact forecasts?
-- Show the count and percentage of all observations
-- for each forecast status.
SELECT
    forecast_status,
    COUNT(*) AS total_forecasts,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_forecasts
FROM
    fact_power_system_load
GROUP BY
    forecast_status
ORDER BY
    total_forecasts DESC;


-- Q9: What are the average absolute error and average percentage error
-- for each forecast status?
SELECT
    forecast_status,
    COUNT(*) AS total_forecasts,
    ROUND(AVG(absolute_error_mw)::NUMERIC, 2) AS average_absolute_error_mw,
    ROUND(
        AVG(absolute_percentage_error)::NUMERIC,
        2
    ) AS average_percentage_error
FROM
    fact_power_system_load
GROUP BY
    forecast_status
ORDER BY
    average_absolute_error_mw DESC;


-- Q10: Which 10 timestamps had the largest absolute forecast errors?
-- Show datetime, actual load, forecasted load, forecast error,
-- and absolute error.
SELECT
    datetime,
    actual_load_mw,
    forecasted_load_mw,
    forecast_error_mw,
    absolute_error_mw
FROM
    fact_power_system_load
ORDER BY
    absolute_error_mw DESC
LIMIT
    10;


-- Q11: At which hours is the forecast least accurate?
-- Calculate the average absolute error for every hour
-- and return the 5 worst hours.
SELECT
    hour,
    ROUND(AVG(absolute_error_mw)::NUMERIC, 2) AS average_absolute_error_mw
FROM
    fact_power_system_load
GROUP BY
    hour
ORDER BY
    average_absolute_error_mw DESC
LIMIT
    5;


-- Q12: At which hours is the forecast most accurate?
-- Calculate the average absolute error for every hour
-- and return the 5 best hours.
SELECT
    hour,
    ROUND(AVG(absolute_error_mw)::NUMERIC, 2) AS average_absolute_error_mw
FROM
    fact_power_system_load
GROUP BY
    hour
ORDER BY
    average_absolute_error_mw ASC
LIMIT
    5;


-- Q13: Which weekdays have the highest average forecast error?
-- Show average signed error, average absolute error,
-- and average percentage error for every weekday.
SELECT
    weekday_number,
    weekday,
    ROUND(AVG(forecast_error_mw)::NUMERIC, 2) AS average_signed_error_mw,
    ROUND(AVG(absolute_error_mw)::NUMERIC, 2) AS average_absolute_error_mw,
    ROUND(
        AVG(absolute_percentage_error)::NUMERIC,
        2
    ) AS average_percentage_error
FROM
    fact_power_system_load
GROUP BY
    weekday_number,
    weekday
ORDER BY
    average_absolute_error_mw DESC;


-- Q14: Which records had actual load above
-- the overall average actual load?
-- Use a subquery to calculate the overall average.
SELECT
    datetime,
    actual_load_mw,
    forecasted_load_mw
FROM
    fact_power_system_load
WHERE
    actual_load_mw > (
        SELECT
            AVG(actual_load_mw)
        FROM
            fact_power_system_load
    )
ORDER BY
    actual_load_mw DESC;


-- Q15: How many observations had an absolute forecast error
-- greater than the average absolute forecast error?
-- Use a subquery.
SELECT
    COUNT(*) AS observations_above_average_error
FROM
    fact_power_system_load
WHERE
    absolute_error_mw > (
        SELECT
            AVG(absolute_error_mw)
        FROM
            fact_power_system_load
    );


-- Q16: Divide actual load into three categories:
-- Low Load: below 18,000 MW
-- Medium Load: from 18,000 MW to 22,000 MW
-- High Load: above 22,000 MW
-- Show the number of observations and average forecast error
-- for each load category.
WITH load_categories AS (
    SELECT
        actual_load_mw,
        forecast_error_mw,
        CASE
            WHEN actual_load_mw < 18000 THEN 'Low Load'
            WHEN actual_load_mw <= 22000 THEN 'Medium Load'
            ELSE 'High Load'
        END AS load_category
    FROM
        fact_power_system_load
)

SELECT
    load_category,
    COUNT(*) AS total_observations,
    ROUND(AVG(forecast_error_mw)::NUMERIC, 2) AS average_forecast_error_mw
FROM
    load_categories
GROUP BY
    load_category
ORDER BY
    CASE load_category
        WHEN 'Low Load' THEN 1
        WHEN 'Medium Load' THEN 2
        WHEN 'High Load' THEN 3
    END;


-- Q17: Compare forecast accuracy between weekdays and weekends.
-- Show MAE, MAPE, and RMSE for both groups.
SELECT
    CASE
        WHEN is_weekend = TRUE THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    ROUND(
        AVG(absolute_error_mw)::NUMERIC,
        2
    ) AS mae_mw,

    ROUND(
        AVG(absolute_percentage_error)::NUMERIC,
        2
    ) AS mape_percent,

    ROUND(
        SQRT(AVG(squared_error_mw2))::NUMERIC,
        2
    ) AS rmse_mw

FROM
    fact_power_system_load
GROUP BY
    is_weekend
ORDER BY
    is_weekend;


-- Q18: What is the average actual load and average forecast error
-- for each date?
-- Order the results chronologically.
SELECT
    date,
    ROUND(AVG(actual_load_mw)::NUMERIC, 2) AS average_actual_load_mw,
    ROUND(AVG(forecast_error_mw)::NUMERIC, 2) AS average_forecast_error_mw
FROM
    fact_power_system_load
GROUP BY
    date
ORDER BY
    date;


-- Q19: Which 5 dates had the highest average actual load?
-- Show the date, average actual load, and maximum actual load.
SELECT
    date,
    ROUND(AVG(actual_load_mw)::NUMERIC, 2) AS average_actual_load_mw,
    MAX(actual_load_mw) AS maximum_actual_load_mw
FROM
    fact_power_system_load
GROUP BY
    date
ORDER BY
    average_actual_load_mw DESC
LIMIT
    5;


-- Q20: Which 5 dates had the highest average absolute forecast error?
-- Show the date, average absolute error,
-- and maximum absolute error.
SELECT
    date,
    ROUND(AVG(absolute_error_mw)::NUMERIC, 2) AS average_absolute_error_mw,
    MAX(absolute_error_mw) AS maximum_absolute_error_mw
FROM
    fact_power_system_load
GROUP BY
    date
ORDER BY
    average_absolute_error_mw DESC
LIMIT
    5;