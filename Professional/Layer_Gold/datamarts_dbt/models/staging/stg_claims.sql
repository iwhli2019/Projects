-- This model cleans and standardizes the Fact_Claims table

select
    "ClaimSK" as claim_sk, -- Surrogate Key
    "ClaimID" as claim_id, -- Natural Key
    "member_id",
    "MemberSK" as member_sk,
    "PolicySK" as policy_sk,
    "ProviderSK" as provider_sk,
    "ClaimDate" as claim_submit_date,
    "ServiceDate" as service_date,
    "ClaimType" as claim_type,
    "ClaimAmount" as claim_amount,
    "affiliation_id" as affiliation_id,
    "PaidAmount" as paid_amount,
    "CopayAmount" as copay_amount,
    "DeductibleAmount" as deductible_amount,
    "ClaimStatus" as claim_status

from {{ source('main', 'Fact_Claims') }}