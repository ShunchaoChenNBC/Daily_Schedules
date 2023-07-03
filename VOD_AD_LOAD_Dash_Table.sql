-- the result append to `nbcu-ds-sandbox-a-001.Shunchao_Sandbox.VOD_AD_LOAD_Table_For_Dash`

select 
adobe_date,
Account_Entitlement,
extract(week from adobe_date) as Week,
set_duration,
Devices,
trim(Primary_Genre) as Primary_Genre, -- remove whitespace
Content_Types,
Ad_Pod_Name,
sum(num_views_started) as Content_Start,
round(sum(ad_viewed),0) as Ad_Unit,
round(sum(Ad_Time_Watched)/60,0) as Ad_Minutes_Watched,
round(sum(num_seconds_played_no_ads)/3600,2) as Hours_Watched
from 
`nbcu-ds-sandbox-a-001.Shunchao_Sandbox.VOD_AD_LOAD_Table` 
where adobe_date = current_date("America/New_York")-1
group by 1,2,3,4,5,6,7,8
