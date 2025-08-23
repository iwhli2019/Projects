-- models/intermediate/int_member_household_income.sql

with household_income as (
    -- First, calculate the total income for each household (defined by address)
    select
        address,
        sum(salary) as household_income
    from
        {{ ref('stg_members') }}
    group by
        1
)

-- Then, map that household income back to each individual member
select
    m.member_sk,
    h.household_income
from
    {{ ref('stg_members') }} as m
join
    household_income as h on m.address = h.address