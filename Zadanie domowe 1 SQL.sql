--zad. 2
select * from facebook_ads_basic_daily;
--zad. 3
select ad_date, spend, clicks, spend / nullif (clicks, 0) as ratio from facebook_ads_basic_daily;
--zad. 4
select 
	ad_date, 
	spend, 
	clicks,
	spend / nullif (clicks, 0) as ratio
from 
	facebook_ads_basic_daily 
where 
	clicks > 0;
--zad. 5
select 
	ad_date,
	spend, 
	clicks, 
	spend / nullif (clicks, 0) as ratio
from 
	facebook_ads_basic_daily
where 
	clicks > 0
order by 
	ad_date desc;
