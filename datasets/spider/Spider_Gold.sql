select count(*) from ship where disposition_of_ship  =  'captured'	battle_death
select name ,  tonnage from ship order by name desc	battle_death
select name ,  date from battle	battle_death
select max(killed) ,  min(killed) from death	battle_death
select avg(injured) from death	battle_death
select t1.killed ,  t1.injured from death as t1 join ship as t2 on t1.caused_by_ship_id  =  t2.id where t2.tonnage  =  't'	battle_death
select name ,  result from battle where bulgarian_commander != 'boril'	battle_death
select distinct t1.id ,  t1.name from battle as t1 join ship as t2 on t1.id  =  t2.lost_in_battle where t2.ship_type  =  'brig'	battle_death
select t1.id ,  t1.name from battle as t1 join ship as t2 on t1.id  =  t2.lost_in_battle join death as t3 on t2.id  =  t3.caused_by_ship_id group by t1.id having sum(t3.killed)  >  10	battle_death
select t2.id ,  t2.name from death as t1 join ship as t2 on t1.caused_by_ship_id  =  t2.id group by t2.id order by count(*) desc limit 1	battle_death
select name from battle where bulgarian_commander  =  'kaloyan' and latin_commander  =  'baldwin i'	battle_death
select count(distinct result) from battle	battle_death
select count(*) from battle where id not in ( select lost_in_battle from ship where tonnage  =  '225' );	battle_death
select t1.name ,  t1.date from battle as t1 join ship as t2 on t1.id  =  t2.lost_in_battle where t2.name  =  'lettice' intersect select t1.name ,  t1.date from battle as t1 join ship as t2 on t1.id  =  t2.lost_in_battle where t2.name  =  'hms atalanta'	battle_death
select name ,  result ,  bulgarian_commander from battle except select t1.name ,  t1.result ,  t1.bulgarian_commander from battle as t1 join ship as t2 on t1.id  =  t2.lost_in_battle where t2.location  =  'english channel'	battle_death
select note from death where note like '%east%'	battle_death
select count(*) from continents;	car_1
select count(*) from continents;	car_1
select t1.contid ,  t1.continent ,  count(*) from continents as t1 join countries as t2 on t1.contid  =  t2.continent group by t1.contid;	car_1
select t1.contid ,  t1.continent ,  count(*) from continents as t1 join countries as t2 on t1.contid  =  t2.continent group by t1.contid;	car_1
select count(*) from countries;	car_1
select count(*) from countries;	car_1
select t1.fullname ,  t1.id ,  count(*) from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker group by t1.id;	car_1
select t1.fullname ,  t1.id ,  count(*) from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker group by t1.id;	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id order by t2.horsepower asc limit 1;	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id order by t2.horsepower asc limit 1;	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t2.weight  <  (select avg(weight) from cars_data)	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t2.weight  <  (select avg(weight) from cars_data)	car_1
select distinct t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker join car_names as t3 on t2.model  =  t3.model join cars_data as t4 on t3.makeid  =  t4.id where t4.year  =  '1970';	car_1
select distinct t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker join car_names as t3 on t2.model  =  t3.model join cars_data as t4 on t3.makeid  =  t4.id where t4.year  =  '1970';	car_1
select t2.make ,  t1.year from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t1.year  =  (select min(year) from cars_data);	car_1
select t2.make ,  t1.year from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t1.year  =  (select min(year) from cars_data);	car_1
select distinct t1.model from model_list as t1 join car_names as t2 on t1.model  =  t2.model join cars_data as t3 on t2.makeid  =  t3.id where t3.year  >  1980;	car_1
select distinct t1.model from model_list as t1 join car_names as t2 on t1.model  =  t2.model join cars_data as t3 on t2.makeid  =  t3.id where t3.year  >  1980;	car_1
select t1.continent ,  count(*) from continents as t1 join countries as t2 on t1.contid  =  t2.continent join car_makers as t3 on t2.countryid  =  t3.country group by t1.continent;	car_1
select t1.continent ,  count(*) from continents as t1 join countries as t2 on t1.contid  =  t2.continent join car_makers as t3 on t2.countryid  =  t3.country group by t1.continent;	car_1
select t2.countryname from car_makers as t1 join countries as t2 on t1.country  =  t2.countryid group by t1.country order by count(*) desc limit 1;	car_1
select t2.countryname from car_makers as t1 join countries as t2 on t1.country  =  t2.countryid group by t1.country order by count(*) desc limit 1;	car_1
select count(*) ,  t2.fullname from model_list as t1 join car_makers as t2 on t1.maker  =  t2.id group by t2.id;	car_1
select count(*) ,  t2.fullname ,  t2.id from model_list as t1 join car_makers as t2 on t1.maker  =  t2.id group by t2.id;	car_1
select t1.accelerate from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t2.make  =  'amc hornet sportabout (sw)';	car_1
select t1.accelerate from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t2.make  =  'amc hornet sportabout (sw)';	car_1
select count(*) from car_makers as t1 join countries as t2 on t1.country  =  t2.countryid where t2.countryname  =  'france';	car_1
select count(*) from car_makers as t1 join countries as t2 on t1.country  =  t2.countryid where t2.countryname  =  'france';	car_1
select count(*) from model_list as t1 join car_makers as t2 on t1.maker  =  t2.id join countries as t3 on t2.country  =  t3.countryid where t3.countryname  =  'usa';	car_1
select count(*) from model_list as t1 join car_makers as t2 on t1.maker  =  t2.id join countries as t3 on t2.country  =  t3.countryid where t3.countryname  =  'usa';	car_1
select avg(mpg) from cars_data where cylinders  =  4;	car_1
select avg(mpg) from cars_data where cylinders  =  4;	car_1
select min(weight) from cars_data where cylinders  =  8 and year  =  1974	car_1
select min(weight) from cars_data where cylinders  =  8 and year  =  1974	car_1
select maker ,  model from model_list;	car_1
select maker ,  model from model_list;	car_1
select t1.countryname ,  t1.countryid from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >=  1;	car_1
select t1.countryname ,  t1.countryid from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >=  1;	car_1
select count(*) from cars_data where horsepower  >  150;	car_1
select count(*) from cars_data where horsepower  >  150;	car_1
select avg(weight) ,  year from cars_data group by year;	car_1
select avg(weight) ,  year from cars_data group by year;	car_1
select t1.countryname from countries as t1 join continents as t2 on t1.continent  =  t2.contid join car_makers as t3 on t1.countryid  =  t3.country where t2.continent  =  'europe' group by t1.countryname having count(*)  >=  3;	car_1
select t1.countryname from countries as t1 join continents as t2 on t1.continent  =  t2.contid join car_makers as t3 on t1.countryid  =  t3.country where t2.continent  =  'europe' group by t1.countryname having count(*)  >=  3;	car_1
select t2.horsepower ,  t1.make from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t2.cylinders  =  3 order by t2.horsepower desc limit 1;	car_1
select t2.horsepower ,  t1.make from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t2.cylinders  =  3 order by t2.horsepower desc limit 1;	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id order by t2.mpg desc limit 1;	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id order by t2.mpg desc limit 1;	car_1
select avg(horsepower) from cars_data where year  <  1980;	car_1
select avg(horsepower) from cars_data where year  <  1980;	car_1
select avg(t2.edispl) from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t1.model  =  'volvo';	car_1
select avg(t2.edispl) from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t1.model  =  'volvo';	car_1
select max(accelerate) ,  cylinders from cars_data group by cylinders;	car_1
select max(accelerate) ,  cylinders from cars_data group by cylinders;	car_1
select model from car_names group by model order by count(*) desc limit 1;	car_1
select model from car_names group by model order by count(*) desc limit 1;	car_1
select count(*) from cars_data where cylinders  >  4;	car_1
select count(*) from cars_data where cylinders  >  4;	car_1
select count(*) from cars_data where year  =  1980;	car_1
select count(*) from cars_data where year  =  1980;	car_1
select count(*) from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker where t1.fullname  =  'american motor company';	car_1
select count(*) from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker where t1.fullname  =  'american motor company';	car_1
select t1.fullname ,  t1.id from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker group by t1.id having count(*)  >  3;	car_1
select t1.fullname ,  t1.id from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker group by t1.id having count(*)  >  3;	car_1
select distinct t2.model from car_names as t1 join model_list as t2 on t1.model  =  t2.model join car_makers as t3 on t2.maker  =  t3.id join cars_data as t4 on t1.makeid  =  t4.id where t3.fullname  =  'general motors' or t4.weight  >  3500;	car_1
select distinct t2.model from car_names as t1 join model_list as t2 on t1.model  =  t2.model join car_makers as t3 on t2.maker  =  t3.id join cars_data as t4 on t1.makeid  =  t4.id where t3.fullname  =  'general motors' or t4.weight  >  3500;	car_1
select distinct year from cars_data where weight between 3000 and 4000;	car_1
select distinct year from cars_data where weight between 3000 and 4000;	car_1
select t1.horsepower from cars_data as t1 order by t1.accelerate desc limit 1;	car_1
select t1.horsepower from cars_data as t1 order by t1.accelerate desc limit 1;	car_1
select t1.cylinders from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t2.model  =  'volvo' order by t1.accelerate asc limit 1;	car_1
select t1.cylinders from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t2.model  =  'volvo' order by t1.accelerate asc limit 1;	car_1
select count(*) from cars_data where accelerate  >  ( select accelerate from cars_data order by horsepower desc limit 1 );	car_1
select count(*) from cars_data where accelerate  >  ( select accelerate from cars_data order by horsepower desc limit 1 );	car_1
select count(*) from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >  2	car_1
select count(*) from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >  2	car_1
select count(*) from cars_data where cylinders  >  6;	car_1
select count(*) from cars_data where cylinders  >  6;	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t2.cylinders  =  4 order by t2.horsepower desc limit 1;	car_1
select t1.model from car_names as t1 join cars_data as t2 on t1.makeid  =  t2.id where t2.cylinders  =  4 order by t2.horsepower desc limit 1;	car_1
select t2.makeid ,  t2.make from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t1.horsepower  >  (select min(horsepower) from cars_data) and t1.cylinders  <=  3;	car_1
select t2.makeid ,  t2.make from cars_data as t1 join car_names as t2 on t1.id  =  t2.makeid where t1.horsepower  >  (select min(horsepower) from cars_data) and t1.cylinders  <  4;	car_1
select max(mpg) from cars_data where cylinders  =  8 or year  <  1980	car_1
select max(mpg) from cars_data where cylinders  =  8 or year  <  1980	car_1
select distinct t1.model from model_list as t1 join car_names as t2 on t1.model  =  t2.model join cars_data as t3 on t2.makeid  =  t3.id join car_makers as t4 on t1.maker  =  t4.id where t3.weight  <  3500 and t4.fullname != 'ford motor company';	car_1
select distinct t1.model from model_list as t1 join car_names as t2 on t1.model  =  t2.model join cars_data as t3 on t2.makeid  =  t3.id join car_makers as t4 on t1.maker  =  t4.id where t3.weight  <  3500 and t4.fullname != 'ford motor company';	car_1
select countryname from countries except select t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country;	car_1
select countryname from countries except select t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country;	car_1
select t1.id ,  t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker group by t1.id having count(*)  >=  2 intersect select t1.id ,  t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker join car_names as t3 on t2.model  =  t3.model group by t1.id having count(*)  >  3;	car_1
select t1.id ,  t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker group by t1.id having count(*)  >=  2 intersect select t1.id ,  t1.maker from car_makers as t1 join model_list as t2 on t1.id  =  t2.maker join car_names as t3 on t2.model  =  t3.model group by t1.id having count(*)  >  3;	car_1
select t1.countryid ,  t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >  3 union select t1.countryid ,  t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country join model_list as t3 on t2.id  =  t3.maker where t3.model  =  'fiat';	car_1
select t1.countryid ,  t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country group by t1.countryid having count(*)  >  3 union select t1.countryid ,  t1.countryname from countries as t1 join car_makers as t2 on t1.countryid  =  t2.country join model_list as t3 on t2.id  =  t3.maker where t3.model  =  'fiat';	car_1
