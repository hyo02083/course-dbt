# Part 1: Models
## What is our user repeat rate?
79.8%
```sql

SELECT div0(count(case when order_cnt >=2 then user_id end)::int ,count(distinct user_id)) as repeat_reate
FROM
(
    SELECT 
        user_id, COUNT(distinct order_id) as order_cnt
    FROM dev_db.dbt_hyo02083webtoonscorpcom.stg_postgres__orders
    WHERE user_id IS NOT NULL
     AND order_id IS NOT NULL 
    group by 1
)

```

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
Users who are likely to purchase again tend to visit frequently or consistently show interest in specific products. For instance, users who have recently completed a purchase or have added multiple items to their cart are more likely to make another purchase. On the other hand, users who are less likely to purchase again may be those who haven’t visited the website for a long time or have repeatedly abandoned their cart without completing the purchase.
Additional data I would like to look into includes the amount of time users spend on product pages, their response to email marketing campaigns, whether they have written reviews, or at what point they abandoned the checkout process.


## Explain the product mart models you added. Why did you organize the models in the way you did?
The product mart models I added combine order data and product data to allow analysis of sales performance and user interactions for each product. Key metrics include sales volume, inventory status, and user reviews for each product. I organized the models this way to reflect the business requirements and make it easier to analyze key product performance indicators. The reason behind this structure is to clearly identify sales trends and optimize inventory management.


# Part 2: Tests
## What assumptions are you making about each model? (i.e. why are you adding each test?)
I applied unique and not-null tests to the PK columns (mainly ID columns) of each model. This is because the PK (primary key) must be unique as it represents a distinct key within the table and should not contain null values.

## Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
While developing the models, I encountered missing or abnormally recorded data, as well as duplicate records. For example, there were cases where the same order ID was recorded multiple times. In this case, I used dbt’s data quality tests to identify and remove duplicate data. Additionally, for missing or anomalous values, I set appropriate assumptions to replace them with either the average or a predefined default value to clean the data.

## Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
To ensure regular testing, I would use dbt’s automation capabilities to run daily data quality tests and set up a dashboard to monitor the test results. In case bad data is detected, I would set up an alert system that automatically notifies stakeholders via email or Slack, ensuring prompt reporting if any issues arise in the data. This way, we can quickly address any problems with the data as they occur.

# Part 3: Snapshots

## The products that had their inventory change from week 1 to week 2
Pothos, Philodendron, Monstera, String of Pearls


``` sql
select 
    distinct product_id, name
from dev_db.dbt_hyo02083webtoonscorpcom.products_snapshot
where dbt_valid_to IS NOT NULL
```