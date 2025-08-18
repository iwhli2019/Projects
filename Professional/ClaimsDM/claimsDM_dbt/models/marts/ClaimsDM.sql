-- This model creates the final, denormalized Claims Data Mart
-- It joins all the staging models to create a single, wide table for analytics.

select
    -- Claim Details from stg_claims
    cl.claim_id,
    cl.service_date,
    cl.claim_date,
    cl.claim_type,
    cl.claim_amount,
    cl.paid_amount,
    cl.copay_amount,
    cl.claim_status,

    -- Member Details from stg_members
    mb.member_id,
    mb.first_name,
    mb.last_name,
    mb.gender,
    mb.marital_status,
    mb.date_of_birth,
    mb.city as member_city,
    mb.province as member_province,
    mb.employer_name,

    -- Provider Details from stg_providers
    pr.provider_id,
    pr.provider_name,
    pr.provider_type,

    -- Policy Details from stg_policies
    po.policy_id,
    po.policy_type,
    po.premium,
    po.deductible,
    po.policy_status,

    -- Business logics
    case
        when cl.claim_status = 'Paid' then 'Completed'
        when cl.claim_status = 'Pending' then 'In Progress'
        else 'Unknown'
    end as claim_status_group,

    case when mb.member_id is not null then 1 else 0 end as flag_is_active

from
    {{ ref('stg_claims') }} as cl
left join
    {{ ref('stg_members') }} as mb
        on cl.member_sk = mb.member_sk
        and cl.service_date between mb.rec_start_date and mb.rec_end_date
left join
    {{ ref('stg_providers') }} as pr on cl.provider_sk = pr.provider_sk
left join
    {{ ref('stg_policies') }} as po on cl.policy_sk = po.policy_sk