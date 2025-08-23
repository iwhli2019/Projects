-- This model creates a monthly date spine, which is a table with one row for every month.

with date_range as (
    -- Get the first and last day of the entire period of activity
    select
        min(start_date) as start_date,
        max(end_date) as end_date
    from {{ ref('stg_policies') }}
),

-- Generate a recursive series of dates from the start to the end date
all_dates as (
    select
        date(start_date) as calendar_date
    from date_range

    union all

    select
        date(calendar_date, '+1 day')
    from all_dates
    where calendar_date < (select end_date from date_range)
),

-- Aggregate the daily dates into a unique list of months
monthly_spine as (
    select
        distinct
        strftime('%Y-%m-01', calendar_date) as month_start_date
    from all_dates
)

select
    date(month_start_date) as month_start_date,
    date(month_start_date, '+1 month', '-1 day') as month_end_date
from monthly_spine
order by 1