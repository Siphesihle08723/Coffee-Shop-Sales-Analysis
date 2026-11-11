 ---------------------------------------------------------------------------
 -- Exporotary data Analysis for Coffee Shop
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
 -- Understanding the Coffee shop Data
  ---------------------------------------------------------------------------
select * 
from `Coffee`.`shop`.`Aanalysis` 
limit 100;

  ---------------------------------------------------------------------------
 -- check if number of raw is the as unuqie
  ---------------------------------------------------------------------------
Select count(*) as num_rows,
       count( distinct transaction_id) as Number_of_transaction
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Checking Diplicate and null value each colomn
  ---------------------------------------------------------------------------
select*
from `Coffee`.`shop`.`Aanalysis`
where transaction_id is null or transaction_date is null or transaction_time is null or
      transaction_qty is null or store_id is null or store_location is null or product_id is null or
      product_category is null or product_type is null or product_detail is null;

 
  ---------------------------------------------------------------------------
 -- Checking the start and the last day of this data (Duration)
  ---------------------------------------------------------------------------    
select min(transaction_date) as starting_date,
       max(transaction_date) as last_date
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Exatract month name and the day name of the transcation
  ---------------------------------------------------------------------------
select transaction_date,
       Monthname(transaction_date) as month_name,
       dayname(transaction_date) as dayname
from `Coffee`.`shop`.`Aanalysis`
group by transaction_date;


  ---------------------------------------------------------------------------
 -- Exactracting time of transaction
 -- Creacte time buckets on the 3 hour interval
  ---------------------------------------------------------------------------

Select transaction_time,
       date_format(transaction_time, 'HH:mm:ss') as time_transaction,
       hour(transaction_time) as hour_of_the_day,
   case
    when time_transaction between '07:00:00' and '09:59:59' then '1. Early morning (7am - 9am)'
    when time_transaction between '10:00:00' and '12:59:59' then '2. Late morning (10am - 12pm)'
    when time_transaction between '13:00:00' and '15:59:59' then '3. Afternoon (1pm - 3pm)'
    when time_transaction between '16:00:00' and '18:59:59' then '4. Evening (4pm - 6pm)'
    else '5. Night'
end as transaction_time_buckets
from `Coffee`.`shop`.`Aanalysis`
group by transaction_time;

  ---------------------------------------------------------------------------
 -- Display all unique store locations
  ---------------------------------------------------------------------------
Select distinct store_location
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Display all unique store locations
  ---------------------------------------------------------------------------
Select distinct store_id
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Display all unique product category
  ---------------------------------------------------------------------------
Select distinct product_category
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Display all unique Product type
  ---------------------------------------------------------------------------
Select distinct product_type
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Display all unique product detail
  ---------------------------------------------------------------------------
Select distinct product_detail
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Display highest price and lowest price
  ---------------------------------------------------------------------------
Select min(unit_price) as lowest_price,
       max(unit_price) as highest_price
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Calculating Revanue(Unit price * transaction_qty)
  ---------------------------------------------------------------------------

select round(sum(unit_price * transaction_qty),2) as total_revenue
from `Coffee`.`shop`.`Aanalysis`;

  ---------------------------------------------------------------------------
 -- Calculating Revanue(Unit price * transaction_qty) base on store_location
  ---------------------------------------------------------------------------

select distinct store_location,
       round(sum(unit_price * transaction_qty),2) as total_revenue
from `Coffee`.`shop`.`Aanalysis`
group by store_location
order by  total_revenue desc;
 ---------------------------------------------------------------------------
 -- Big Cleaned Query
  ---------------------------------------------------------------------------
select
    transaction_id,
    transaction_date,
    monthname(transaction_date) as month_name,
    dayname(transaction_date) as day_name,
    hour(transaction_time) as transaction_hour,
    case
    when dayofweek(transaction_date) in (1, 7) then 'Weekend'
    else 'Weekday'
    end as day_type,
    store_id,
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    transaction_qty,
    unit_price,
    round(sum(unit_price * transaction_qty), 2) as total_amount,
    case
        when hour(transaction_time) between 7 and 9 then '1. early morning (07:00 - 09:59)'
        when hour(transaction_time) between 10 and 12 then '2. late morning (10:00 - 12:59)'
        when hour(transaction_time) between 13 and 15 then '3. afternoon (13:00 - 15:59)'
        when hour(transaction_time) between 16 and 18 then '4. evening (16:00 - 18:59)'
        else '5. night'
    end as transaction_time_bucket
from `Coffee`.`shop`.`Aanalysis`
group by transaction_id, transaction_date, transaction_time, store_id, store_location, 
         product_id, product_category, product_type, product_detail, transaction_qty, unit_price;
