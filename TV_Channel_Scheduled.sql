select 
a.adobe_date,
EXTRACT(hour from a.Start_Time) as Start_Hour,
a.adobe_tracking_id,
lower(a.Channels) as Channels,
case when device_name in ('Android Mobile','Ios Mobile') then "Mobile"
when device_name = "Www" then "Web"
else "CTV" end as Platform,
round(sum(a.num_seconds_played_no_ads)/3600,2) as Watch_Hours, -- 0.01 intervel
round(sum(a.num_seconds_played_no_ads)/60,2) as Watch_Minutes -- add minute column for 5 minute cutoff
from
(SELECT 
adobe_date,
timestamp_sub(adobe_timestamp, interval cast(num_seconds_played_no_ads as INT64) second) as Start_Time,
adobe_tracking_id,
case when consumption_type = 'Virtual Channel' then display_name
	         else playlist_name end as Channels,
device_platform,
device_name,
num_seconds_played_no_ads 
FROM `nbcu-ds-prod-001.PeacockDataMartSilver.SILVER_VIDEO` 
WHERE adobe_date between current_date("America/New_York")-7 and current_date("America/New_York")-1
and num_seconds_played_no_ads > 0) a
where 1=1
and (lower(Channels) LIKE "%-tv%" or Channels like "% | %" 
or length(Channels) = 4 or (regexp_contains(Channels, r"\w{4}-\w{2}") and length(Channels) <= 7)
or lower(Channels) in (select distinct lower(string_field_0) from `nbcu-ds-sandbox-a-001.LaluO_Sandbox.affiliate_channels`))
and lower(Channels) not in ("kane","edge","omos","otis","cnbc","news","imsa","bige","golf")
group by 1,2,3,4,5