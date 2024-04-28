/* https://dataexpert.io/question/subcat-per-region */

use memory.playground;

/* Sample data */
drop table if exists playground.superstore;
create table playground.superstore (
    row_id        int,
    order_id      varchar,
    order_date    date,
    ship_date     date,
    ship_mode     varchar,
    customer_id   varchar,
    customer_name varchar,
    segment       varchar,
    country       varchar,
    city          varchar,
    state         varchar,
    postal_code   int,
    region        varchar,
    product_id    varchar,
    category      varchar,
    sub_category  varchar,
    product_name  varchar,
    sales         varchar,
    quantity      varchar,
    discount      varchar,
    profit        double
);
insert into playground.superstore
values
    (1,  'CA-2016-152156', cast('2016-08-11' as date), cast('2016-11-11' as date), 'Second Class',   'CG-12520', 'Claire Gute',     'Consumer',  'United States', 'Henderson',       'Kentucky',   42420, 'South', 'FUR-BO-10001798', 'Furniture',       'Bookcases',   'Bush Somerset Collection Bookcase',                                '261.96', '2', '0.0',  41.9),
    (2,  'CA-2016-152156', cast('2016-08-11' as date), cast('2016-11-11' as date), 'Second Class',   'CG-12520', 'Claire Gute',     'Consumer',  'United States', 'Henderson',       'Kentucky',   42420, 'South', 'FUR-CH-10000454', 'Furniture',       'Chairs',      'Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back',      '731.94', '3', '0.0',  219.6),
    (3,  'CA-2016-138688', cast('2016-12-06' as date), cast('2016-06-16' as date), 'Second Class',   'DV-13045', 'Darrin Van Huff', 'Corporate', 'United States', 'Los Angeles',     'California', 90036, 'West',  'OFF-LA-10000240', 'Office Supplies', 'Labels',      'Self-Adhesive Address Labels for Typewriters by Universal',        '14.62',  '2', '0.0',  6.9),
    (4,  'US-2015-108966', cast('2015-11-10' as date), cast('2015-10-18' as date), 'Standard Class', 'SO-20335', 'Sean O''Donnell', 'Consumer',  'United States', 'Fort Lauderdale', 'Florida',    33311, 'South', 'FUR-TA-10000577', 'Furniture',       'Tables',      'Bretford CR4500 Series Slim Rectangular Table',                    '957.58', '5', '0.45', -383),
    (5,  'US-2015-108966', cast('2015-11-10' as date), cast('2015-10-18' as date), 'Standard Class', 'SO-20335', 'Sean O''Donnell', 'Consumer',  'United States', 'Fort Lauderdale', 'Florida',    33311, 'South', 'OFF-ST-10000760', 'Office Supplies', 'Storage',     'Eldon Fold ''N Roll Cart System',                                  '22.37',  '2', '0.2',  2.5),
    (6,  'CA-2014-115812', cast('2014-09-06' as date), cast('2014-06-14' as date), 'Standard Class', 'BH-11710', 'Brosina Hoffman', 'Consumer',  'United States', 'Los Angeles',     'California', 90032, 'West',  'FUR-FU-10001487', 'Furniture',       'Furnishings', 'Eldon Expressions Wood and Plastic Desk Accessories, Cherry Wood', '48.86',  '7', '0.0',  14.2),
    (7,  'CA-2014-115812', cast('2014-09-06' as date), cast('2014-06-14' as date), 'Standard Class', 'BH-11710', 'Brosina Hoffman', 'Consumer',  'United States', 'Los Angeles',     'California', 90032, 'West',  'OFF-AR-10002833', 'Office Supplies', 'Art',         'Newell 322',                                                       '7.28',   '4', '0.0',  2),
    (8,  'CA-2014-115812', cast('2014-09-06' as date), cast('2014-06-14' as date), 'Standard Class', 'BH-11710', 'Brosina Hoffman', 'Consumer',  'United States', 'Los Angeles',     'California', 90032, 'West',  'TEC-PH-10002275', 'Technology',      'Phones',      'Mitel 5320 IP Phone VoIP phone',                                   '907.15', '6', '0.2',  90.7),
    (9,  'CA-2014-115812', cast('2014-09-06' as date), cast('2014-06-14' as date), 'Standard Class', 'BH-11710', 'Brosina Hoffman', 'Consumer',  'United States', 'Los Angeles',     'California', 90032, 'West',  'OFF-BI-10003910', 'Office Supplies', 'Binders',     'DXL Angle-View Binders with Locking Rings by Samsill',             '18.5',   '3', '0.2',  5.8),
    (10, 'CA-2014-115812', cast('2014-09-06' as date), cast('2014-06-14' as date), 'Standard Class', 'BH-11710', 'Brosina Hoffman', 'Consumer',  'United States', 'Los Angeles',     'California', 90032, 'West',  'OFF-AP-10002892', 'Office Supplies', 'Appliances',  'Belkin F5C206VTEL 6 Outlet Surge',                                 '114.9',  '5', '0.0',  34.5)
;


------------------------------------------------------------------------
------------------------------------------------------------------------

/*
This should absolutely definitely by "Medium", at most.

Using a correlated subquery instead of a window function for funsies.
*/

/* Solution */
with sales as (
    select
        region,
        sub_category,
        -- sum(try_cast(quantity as double)) as purchase_count,
        count(*) as purchase_count /* This feels wrong? */
    from playground.superstore
    group by region, sub_category
)

select
    region,
    sub_category,
    purchase_count
from sales
where purchase_count = (
    select max(purchase_count)
    from sales as sales_inner
    where sales.region = sales_inner.region
)
order by region
;
