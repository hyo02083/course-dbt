# Part 1 
## What is our overall conversion rate?  --구매 이벤트 세션 수 / 총 세션 수
 -  62.46%

 ```sql
SELECT 
    round(COUNT(DISTINCT CASE WHEN checkouts  = 1 THEN session_id END)/COUNT(DISTINCT session_id) *100,2) as conversion_rate
FROM dev_db.dbt_hyo02083webtoonscorpcom.fact_page_views

 ```


## What is our conversion rate by product? -- 작품별 구매 이벤트 세션 수 / 총 세션 수

```
PRODUCT_ID	CONVERSION_RATE
05df0866-1a66-41d8-9ed7-e2bbcddd6a3d	45.00
35550082-a52d-4301-8f06-05b30f6f3616	48.89
37e0062f-bd15-4c3e-b272-558a86d90598	46.77
4cda01b9-62e2-46c5-830f-b7f262a58fb1	34.43
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	48.39
579f4cd0-1f45-49d2-af55-9ab2b72c3b35	51.85
58b575f2-2192-4a53-9d21-df9a0c14fc25	39.34
5b50b820-1d0a-4231-9422-75e7f6b0cecf	47.46
5ceddd13-cf00-481f-9285-8340ab95d06d	49.25
615695d3-8ffd-4850-bcf7-944cf6d3685b	49.23
64d39754-03e4-4fa0-b1ea-5f4293315f67	47.46
689fb64e-a4a2-45c5-b9f2-480c2155624d	53.73
6f3a3072-a24d-4d11-9cef-25b0b5f8a4af	41.18
74aeb414-e3dd-4e8a-beef-0fa45225214d	55.56
80eda933-749d-4fc6-91d5-613d29eb126f	41.89
843b6553-dc6a-4fc4-bceb-02cd39af0168	42.65
a88a23ef-679c-4743-b151-dc7722040d8c	47.83
b66a7143-c18a-43bb-b5dc-06bb5d1d3160	53.97
b86ae24b-6f59-47e8-8adc-b17d88cbd367	50.94
bb19d194-e1bd-4358-819e-cd1f1b401c0c	42.31
be49171b-9f72-4fc9-bf7a-9a52e259836b	51.02
c17e63f7-0d28-4a95-8248-b01ea354840e	54.55
c7050c3b-a898-424d-8d98-ab0aaad7bef4	45.33
d3e228db-8ca5-42ad-bb0a-2148e876cc59	46.43
e18f33a6-b89a-4fbc-82ad-ccba5bb261cc	40.00
e2e78dfc-f25c-4fec-a002-8e280d61a2f2	41.27
e5ee99b6-519f-4218-8b41-62f48f59f700	40.91
e706ab70-b396-4d30-a6b2-a1ccf3625b52	50.00
e8b6528e-a830-4d03-a027-473b411c7f02	39.73
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	60.94

```



```sql
SELECT
    product_id
    ,round(COUNT(DISTINCT CASE WHEN checkouts  = 1 THEN session_id END)/COUNT(DISTINCT session_id) *100,2) as conversion_rate
FROM dev_db.dbt_hyo02083webtoonscorpcom.fact_page_views
group by 1
order by 1
```



# Part 2
## Create a macro to simplify part of a model(s).
- The macro sum_of was created and it was used in the model fact_page_views.
    - macros/sum_of.sql
    - models/marts/product/fact_page_views.sql


# Part 3
## Add a post hook to your project to apply grants to the role “reporting”. 
 - The macro grant was created and used and the post hook was added in dbt_project.yml.


# Part 4
## Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project
 - The package dbt_expectations was installed and the macro dbt_utils.accepted_range was used as a test for the column order_total in stg_postgres__orders table.


# Part 5
## Show (using dbt docs and the model DAGs) how you have simplified or improved a DAG using macros and/or dbt packages.
 - My DAG did not change from last week. I did not find a way to simplify it by using macros/dbt packages.


# Part 6
## Run the products snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week. 
## Which products had their inventory change from week 2 to week 3? 

```
PRODUCT_ID	NAME
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	Philodendron
be49171b-9f72-4fc9-bf7a-9a52e259836b	Monstera
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls
```

```sql
select 
    distinct product_id, name
from dev_db.dbt_hyo02083webtoonscorpcom.products_snapshot
WHERE dbt_valid_from::date BETWEEN date'2024-10-15' AND date'2024-10-21' --week2
 AND dbt_valid_to::date BETWEEN date'2024-10-22' AND date'2024-10-28' --week3 
 order by 1,2
```
