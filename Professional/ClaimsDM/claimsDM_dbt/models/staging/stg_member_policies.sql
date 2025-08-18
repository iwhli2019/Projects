-- This model cleans and standardizes the Dim_Member_Policies junction table

select
    "MemberPolicySK" as member_policy_sk,
    "MemberSK" as member_sk,
    "PolicySK" as policy_sk,
    "EffectiveDate" as effective_date

from {{ source('silver_layer', 'Dim_Member_Policies') }}