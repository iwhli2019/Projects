-- This model cleans and standardizes the Dim_Policy table

select
    "PolicySK" as policy_sk,
    "PolicyID" as policy_id,
    "PolicyType" as policy_type,
    "StartDate" as start_date,
    "EndDate" as end_date,
    "Premium" as premium,
    "Deductible" as deductible,
    "CoPay" as copay,
    "EmployerName" as employer_name

from {{ source('silver_layer', 'Dim_Policy') }}