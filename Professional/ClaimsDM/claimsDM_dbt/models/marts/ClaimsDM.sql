-- It joins all the staging models to create a single, wide table for analytics.

select
    -- Claim Details
    cl.claim_id,
    cl.service_date,
    cl.submit_date as claim_submit_date,
    cl.claim_type,
    cl.submitted_amt as claim_amount,
    cl.paid_amt as paid_amount,
    
    -- Member Details
    mb.member_id,
    mb.first_name,
    mb.last_name,
    mb.gender,
    mb.marital_status,
    mb.date_of_birth,
    mb.city as member_city,
    mb.is_transfer_policy,
    
    -- Company Details
    co.company_name,
    co.city as company_city,
    co.company_province,
    co.is_multi_location,

    -- Provider Details
    pr.provider_name,
    pr.provider_type,
    pr.city as provider_city,

    -- Policy Details
    po.policy_id,
    po.plan_name as policy_plan_name,
    po.deductible as policy_deductible,

    -- Self-defined demo group/calculation
    hh.household_income,
    cast(julianday(cl.service_date) - julianday(mb.date_of_birth) as integer) / 365 as member_age_at_claim,

    -- Business Logic
    case
        when mb.rec_end_date is null then 1
        else 0
    end as is_member_active,
    
   cast(julianday(cl.claim_submit_date) - julianday(cl.service_date) as integer) as claim_lag_days,

    case
        when cast(julianday(cl.service_date) - julianday(
            lag(cl.service_date, 1) over (partition by mb.member_id order by cl.service_date)
        ) as integer) <= 30 then 1
        else 0
    end as is_30_day_readmission    

from
    {{ ref('stg_claims') }} as cl
left join
    {{ ref('stg_members') }} as mb
        on cl.member_id = mb.member_id
        and cast(cl.service_date as date) between cast(mb.rec_start_date as date) and coalesce(cast(mb.rec_end_date as date), date('now'))
left join
    {{ ref('stg_companies') }} as co 
        on mb.company_id = co.company_id
left join
    {{ ref('stg_providers') }} as pr 
        on cl.affiliation_id = pr.affiliation_id
left join
    {{ ref('stg_member_policies') }} as mp 
        on mb.member_id = mp.member_id 
        and cast(cl.service_date as date) between cast(mp.policy_start_date as date) and coalesce(cast(mp.policy_end_date as date), date('now'))
left join
    {{ ref('stg_policies') }} as po 
        on mp.policy_id = po.policy_id
left join
    {{ ref('int_ClaimsDM_member_household_income') }} as hh
        on mb.member_sk = hh.member_sk
