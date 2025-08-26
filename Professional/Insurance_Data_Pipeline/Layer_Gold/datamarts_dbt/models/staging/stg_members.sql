-- This model cleans and standardizes the Dim_Member table

select
    "MemberSK" as member_sk, -- Surrogate Key
    "MemberID" as member_id, -- Natural Key
    "FirstName" as first_name,
    "LastName" as last_name,
    "DateOfBirth" as date_of_birth,
    "Address" as address,
    "City" as city,
    "Province" as province,
    "PostalCode" as postal_code,
    "Gender" as gender,
    "company_id" as company_id,
    "MaritalStatus" as marital_status,
    "EmployerName" as employer_name,
    "Salary" as salary,
    "is_transfer_policy" as flag_is_transfer_policy,
    "rec_start_date",
    "rec_end_date"

from {{ source('main', 'Dim_Member') }}