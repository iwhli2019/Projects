-- This model cleans and standardizes the Dim_Member_Policies junction table

select
    "MemberPolicySK" as member_policy_sk,
    "MemberSK" as member_sk,
    "member_id" as member_id,
    "PolicySK" as policy_sk,
    "EffectiveDate" as effective_date,
    "policy_id" as policy_id,
    "policy_start_date" as policy_start_date,
    "policy_end_date" as policy_end_date

from {{ source('main', 'Dim_Member_Policies') }}