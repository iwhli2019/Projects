{{
  config(
    materialized='table',
    schema="main"
  )
}}

with date_spine as (
    select * from {{ ref('int_MemberPortfolioDM_date_spine') }}
),

member_policies as (
    select
        mp.member_sk,
        p.policy_sk,
        p.start_date,
        coalesce(p.end_date, date('now')) as end_date
    from
        {{ ref('stg_member_policies') }} as mp
    join
        {{ ref('stg_policies') }} as p on mp.policy_sk = p.policy_sk
),

member_month_scaffold as (
    select
        d.month_start_date,
        m.member_sk
    from
        date_spine as d
    cross join
        {{ ref('stg_members') }} as m
),

monthly_status as (
    select
        s.month_start_date,
        s.member_sk,
        case
            when count(p.policy_sk) > 0 then 1
            else 0
        end as is_active_this_month
    from
        member_month_scaffold as s
    left join
        member_policies as p on s.member_sk = p.member_sk
        and s.month_start_date between date(p.start_date) and date(p.end_date)
    group by
        1, 2
),

-- Use the LAG function to get the previous month's status for each member
final as (
    select
        month_start_date,
        member_sk,
        is_active_this_month,
        lag(is_active_this_month, 1, 0) over (partition by member_sk order by month_start_date) as is_active_last_month
    from
        monthly_status
)

-- Final classification of member status for the month
select
    month_start_date,
    member_sk,
    is_active_this_month,
    is_active_last_month,
    case
        when is_active_this_month = 1 and is_active_last_month = 0 then 'New'
        when is_active_this_month = 1 and is_active_last_month = 1 then 'Retained'
        when is_active_this_month = 0 and is_active_last_month = 1 then 'Lapsed'
        else 'Inactive'
    end as member_status
from
    final