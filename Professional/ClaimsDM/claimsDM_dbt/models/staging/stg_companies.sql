-- This model cleans and standardizes the Dim_Company table

select
    company_id,
    company_name,
    company_address,
    company_province,
    city,
    
    -- Calculate the is_multi_location flag using a window function in a CASE statement
    case 
        when count(company_id) over (partition by company_name) > 1 then 1
        else 0
    end as is_multi_location

from {{ source('silver_layer', 'Dim_Company') }}