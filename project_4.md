# Part 1. dbt Snapshots

### 2) Which products had their inventory change from week 3 to week 4? 
```sql
select 
    distinct product_id, name
from dev_db.dbt_hyo02083webtoonscorpcom.products_snapshot
WHERE dbt_updated_at::date BETWEEN date'2024-10-21' AND date'2024-10-27' --week3
order by 1,2
```

PRODUCT_ID	NAME
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	Philodendron
689fb64e-a4a2-45c5-b9f2-480c2155624d	Bamboo
b66a7143-c18a-43bb-b5dc-06bb5d1d3160	ZZ Plant
be49171b-9f72-4fc9-bf7a-9a52e259836b	Monstera
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls


### 3-1) Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? 


```sql
select
    name, count(*) as change_count
from dev_db.dbt_hyo02083webtoonscorpcom.products_snapshot
group by name
having change_count > 1
order by change_count desc
```

NAME	CHANGE_COUNT
Pothos	4
String of pearls	4
Monstera	4
Philodendron	4
Bamboo	3
ZZ Plant	3


### 3-2) Did we have any items go out of stock in the last 3 weeks? 
```sql
select * 
from dev_db.dbt_hyo02083webtoonscorpcom.products_snapshot
where inventory = 0
```

PRODUCT_ID	NAME
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos



# Part 2. Modeling challenge

### How are our users moving through the product funnel?
``` sql
WITH base AS (
    select 
        count(distinct case when page_views > 0 then session_id end) as page_views,
        count(distinct case when add_to_carts > 0 then session_id end) as add_to_carts,
        count(distinct case when checkouts > 0 then session_id end) as checkouts
    from dev_db.dbt_hyo02083webtoonscorpcom.fact_page_views
)
select
    round(page_views/page_views*100,2) as page_view_ratio,
    round(add_to_carts/page_views*100,2) as views_to_cart_ratio,
    round(checkouts/add_to_carts*100,2) as cart_to_checkout_ratio
from base


```
PAGE_VIEW_RATIO	VIEWS_TO_CART_RATIO	CART_TO_CHECKOUT_RATIO
100.00	80.80	77.30


### Which steps in the funnel have largest drop off points?
- add to cart to checkout



