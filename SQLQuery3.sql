select * from IPLPlayers;

select team  from IPLPlayers group by team;

 select Team, sum(price_in_cr)  as total_cost from IPLPlayers group by team order by total_cost  desc;

 --find the top 3 higest-paid 'all-rounder' across all team:

select  top 3 player, team, price_in_cr from IPLPlayers 
where role ='All-rounder' order by Price_in_cr desc;

-- find the  highest-price player in each team--\

select * from IPLPlayers order by Price_in_cr desc;

with CTE_MP as(
select  team, max(Price_in_cr) as MaxPrice from IPLPlayers group by team )

select i.Team, i.player, c.MaxPrice  from IPLPlayers i 
join CTE_MP c on i.team = c.team  where i.Price_in_cr = c.maxprice;
 
 -- rank  players  by their price within each team  and list  the top 2 for	every team;

 with rank_player as (select player, team, price_in_cr , ROW_NUMBER() over 
 (partition by team order by price_in_cr desc) as rankd from  IPLPlayers )

 select player, Team, Price_in_cr, rankd from rank_player  where rankd <=2

--Q5 fine most expensive players from each team, along with the second-most expenisve player's name and price 
with rank_player as (select player, team, price_in_cr , ROW_NUMBER() over 
 (partition by team order by price_in_cr desc) as rankd from  IPLPlayers )

 select team,  
max(CASE WHEN rankd =1 THEN player END) as most_expensive_player, 
max(CASE WHEN rankd =1 THEN price_in_cr end) as highest_expensive_player,
max(CASE WHEN rankd =2 THEN player end) as second_expensive_player, 
max(CASE WHEN rankd =2 THEN price_in_cr end) as second_2_expensive_player
 from rank_player group by team

 --CALCULATE THE PERCENTAGE CONTRIBUTED OF EACH PLAYER'S PRICE TO THEIR TEAM'S TOTAL SPEDNING 

 select player, team, price_in_cr, cast(price_in_cr/ (sum(price_in_cr) over (partition by team))* 100 as decimal(10,2)) as contribution_Percentage 
 from IPLPlayers;

 --classify players as 'high', 'meduim', or low priced based on the following rules:
 ---high : price > $15 core
 ---medium price between $5 crore and $15 crore
 ---low: price < $ 5 crore
 ---and find out the number of players in each bracet	

 with cte_br as (select team, Player, Price_in_cr,
 case 
		when price_in_cr > 15 then 'high'
		when price_in_cr between 5 and 15 then 'medium'
		else 'low'
	end as price_category
 from IPLPlayers 
)

select team, price_category, count(*)  as 
'noofplayer' from cte_br group by team, 
price_category order by team, price_category

--find the average price of indian prayer  and compare	it with overseas player using  a subquery
select 'indian' as playertype,
(select (avg(price_in_cr)  from IPLPlayers where type like 'Indian%') as avgprice
union all 
select 'oversea' as playertype2,
(select avg(price_in_cr)  from IPLPlayers where type like 'oversea%') as avgprice

-- identify players who earn more than the average price their team:

select * from IPLPlayers
select player, Team, price_in_cr 
from IPLPlayers p
where Price_in_cr >  (select avg(price_in_cr) from 
			IPLPlayers where team = p.team)
---for each role, find the most expenisve players and their price using a correlated subquery

select  player,Team, role, price_in_Cr from IPLPlayers p where Price_in_cr = (
select max(price_in_cr) from IPLPlayers where role = p.role)