/*
-- next code for MYSQL 5.7:

 calendar_weeks is a VIEW based on table:
 -- calendar_dates

 Please create and fill this table before

 the working_hours is 8 per working_day
 */

CREATE OR REPLACE VIEW calendar_years AS
(
SELECT last_day_of_year.year,
       last_day_of_year.year2,
       last_day_of_year.year2c,
       last_day_of_year.year_begin,
       last_day_of_year.year_end,
       DATE_ADD(last_day_of_year.year_end, INTERVAL 1 DAY) AS year_after_begin,
       last_day_of_year.year_after                         AS year_after_end,
       last_day_of_year.year_before                        AS year_before_end,
       last_day_of_year.days_in_year,
       last_day_of_year.days_in_year * 24                  AS hours_in_year,
       dates_of_year.weekdays,
       dates_of_year.weekends,
       dates_of_year.special_days,
       dates_of_year.working_days,
       CASE
           WHEN last_day_of_year.days_in_year = 365
               THEN 0
           ELSE 1 END                                      AS is_leap_year,
       last_day_of_year.year_num_since_2020                AS order_year_number

FROM calendar_dates AS last_day_of_year
    LEFT JOIN (SELECT year,
                      SUM(is_weekday)     AS weekdays,
                      SUM(is_weekend)     AS weekends,
                      SUM(CASE
                              WHEN special_date IS NOT NULL
                                  THEN 1
                              ELSE 0 END) AS special_days,
                      SUM(CASE
                              WHEN is_working_day
                                  THEN 1
                              ELSE 0 END) AS working_days
               FROM calendar_dates
               GROUP BY year) AS dates_of_year
        ON dates_of_year.year = last_day_of_year.year
WHERE last_day_of_year.is_last_day_of_year = 1
    );

#check..
SELECT *
FROM calendar_years;

/*
 sza(c)
 */