set echo on;
alter session set recyclebin = off;
spool ScallerDatbaseDesign;
set linesize=200;
set pagesize=66;


alter session set nls_date_format='mm-dd-yy';

drop view Attendance1031;
drop view Attendance9856974323;
drop table recurring_gift;
drop table pledge;
drop table pledge_type;
drop table credit_card;
drop table gift_schedule;
drop table gift;
drop table emp_schedule;
drop table training_session;
drop table offer;
drop table problem;
drop table disciplinary;
drop table coaching;
drop table call;
drop table prospect_matching;
drop table prospect;
drop table spouse;
drop table caller;
drop table interview;
drop table manager;
drop table applicant;
drop table supervisor;
drop table management;
drop table person;
drop table score;
drop table zip;
drop table timeslot;
drop table timeperiod;
drop table status;
drop table day;
drop table calling_pool;
drop table donor_type;
drop table call_result;
drop table department;
drop table training_type;
drop table action_taken;
drop table reason_for_action;
drop table major;
drop table matching_company;
drop cluster gift_cluster;

create table Matching_Company(
company_ID number(10) constraint mc_pk primary key not null,
description varchar2(999) not null,
rate varchar2(30) not null);

create table Major(
major varchar2(99) constraint major_pk primary key,
description varchar2(999) not null);

create table reason_for_Action (
Reason_code varchar2(50) constraint action_pk primary key, 
Description varchar2(999) not null);

create table action_taken (
Action_code varchar2(50) constraint action_code_pk primary key,
Description varchar2(999) not null);

create table training_type (
training_type varchar2(20) constraint training_type_pk primary key); 

create table department (
department varchar2(20) constraint department_pk primary key,
description varchar2(999) not null);

create table call_result (
result_code varchar2(50) constraint call_result_pk primary key,
description varchar2(999) not null);

create table donor_type (
Donor_type varchar2(50) constraint donor_pk primary key,
description varchar2(999) not null);

create table calling_pool (
CP_code varchar2(50) constraint calling_pool_pk primary key,
Department varchar2(20) constraint callingpool_department_fk references department not null,
description varchar2(999) not null, 
num_records number not null,
percent_of_total number not null,
comp_num number not null,
comp_rate number not null,
cont_num number not null,
cont_rate number not null,
spec_amt number not null,
match_am number not null,
total_amt number not null,
credit_percent number not null,
credit_amt number not null,
avg_spec_amt number not null,
avg_total_amt number not null,
pledge_rate number not null,
Donor_Type varchar2(50) constraint callingpool_donortype_fk references donor_type not null);

create table day (
Day_id number(6) constraint day_pk primary key,
d_date date not null);

create table status (
Status_code varchar2(50) constraint status_pk primary key,
description varchar2(999) not null);

create table timeperiod (
Time_period_id varchar2(30) constraint timeperiod_pk primary key, 
time_period varchar2(99) not null);

Create table timeslot(
Day_id number(6) constraint timeslot_day_fk references day,
Time_period_id varchar2(99) constraint ts_timeperiod_fk references timeperiod,
Emp_num number(2),
Primary key (Day_id,Time_period_id));

create table ZIP (
ZIP number(5) constraint zip_pk primary key,
city varchar2(15) not null,
state varchar2(20) not null);

CREATE INDEX zip_city ON ZIP (city);
CREATE INDEX zip_state ON ZIP (state);

create table score (
Score number(1) constraint score_pk primary key, 
s_desc varchar2(99) constraint score_desc_null not null);

create table person (
person_id number(10) constraint person_pk primary key, 
fn varchar2(20) not null, 
ln varchar2(20) not null, 
DOB date not null, 
SSN number(9), 
phone_num number(10) not null,
email varchar2(30) not null,
street varchar2(30) not null,
ZIP number(5) constraint person_zip_fk references zip
          constraint person_zip_null not null,
major varchar2(99) constraint person_major_fk references major);

CREATE INDEX person_fn ON person(fn);
CREATE INDEX person_ln ON person(ln);

create table management (
person_id number(10) constraint m_person_fk references person not null primary key);

create table supervisor (
person_id number(10) constraint s_management_fk references management not null primary key);

create table manager (
person_id number(10) constraint m_management_fk references management not null primary key);

create table applicant (
person_id number(10) constraint applicant_person_fk references person not null primary key,
grad_year number(4) not null);

create table interview (
Interview_id number(10) constraint interview_pk primary key, 
Manager_id number(10) constraint interview_manager_fk references manager not null, 
applicant_id number(10) constraint interview_applicant_fk references applicant not null, 
Interview_date date not null);

create table caller (
person_id number(10) constraint caller_person_fk references person not null primary key,
coach_score_avg_lw number(2,1), 
coach_score_avg number(2,1), 
coach_intro_avg_lw number(2,1), 
coach_rapport_avg_lw number(2,1), 
coach_ask_avg_lw number(2,1), 
coach_close_avg_lw number(2,1), 
calls_num_lw number(10) not null, 
calls_num_total number(10) not null, 
hour_lw number(5) not null, 
hw_lm number(5) not null, 
ncns number(3) not null, 
rfdo number(3) not null, 
tardy number(3) not null, 
sent_h_wo_pay number(3) not null, 
unexcused_rfdo number(3) not null, 
make_up_shift number(3) not null, 
coach_score_avg_lw2 number(2,1), 
coach_score_avg_lw3 number(2,1), 
coach_score_avg_lw4 number(2,1), 
coach_score_avg_lw5 number(2,1), 
coach_score_avg_lw6 number(2,1),
interview_id number(10) constraint c_interview_fk references interview not null);

create table spouse (
person_id number(10) constraint spouse_person_fk references person not null primary key);

create table prospect (
person_id number(10) constraint prospect_person_fk references person not null primary key, 
CP_code varchar2(50) constraint p_callingpool_fk references calling_pool not null, 
title varchar2 (20) not null,
grad_date date not null,
school varchar2(30) not null,
degree varchar2(30) not null,
campus varchar2(30) not null,
spouse_id number(10) constraint prospect_spouse_fk references spouse);

CREATE INDEX prospect_cp ON prospect (CP_code);


create table Prospect_matching(
company_ID number(10) constraint pm_company_fk references matching_company,
prospect_ID number(10) constraint pm_prospect_fk references prospect,
PRIMARY KEY(company_ID, prospect_ID));

create table call (
Call_id number(10) constraint call_pk primary key,
caller_id number(10) constraint call_caller_fk references caller, 
prospect_id number(10) not null constraint call_prospect_fk references prospect,
result_code varchar2(50) not null constraint call_callresult_fk references call_result,
date_time date not null,
comp varchar2(1) check (comp in('Y','N')), 
cont varchar2(1) check (cont in('Y','N')), 
total_amt number(10) not null, 
pay_date date, 
match_amt number(10) not null);

CREATE INDEX call_caller ON call (caller_id);
CREATE INDEX call_prospect ON call (prospect_id);
CREATE INDEX call_result ON call (result_code);


create table coaching (
call_id number(10) constraint coaching_call_kf references call primary key not null, 
intro_name varchar2(1) check (intro_name in('Y','N')), 
intro_aff varchar2(1) check (intro_aff in('Y','N')), 
intro_padd varchar2(1) check (intro_padd in('Y','N')), 
rap_sum varchar2(999), 
rap_time varchar2(20), 
rap_trans varchar2(1) check (rap_trans in('Y','N')), 
rap_comment varchar2(999), 
ask_sum varchar2(999), 
ask_comment varchar2(999), 
demo_add varchar2(1) check (demo_add in('Y','N')), 
demo_emp varchar2(1) check (demo_emp in('Y','N')), 
close_su varchar2(1) check (close_su in('Y','N')), 
upgradeask varchar2(1) check (upgradeask in('Y','N')), 
matchinggift varchar2(1) check (matchinggift in('Y','N')), 
CCask1 varchar2(1) check (CCask1 in('Y','N')), 
CCask2 varchar2(1) check (CCask2 in('Y','N')), 
intro_score number(1) constraint coaching_score_fk references score, 
rap_score number(1) constraint coaching_score_fk2 references score, 
ask_score number(1) constraint coaching_score_fk3 references score,  
close_score number(1) constraint coaching_score_fk4 references score,
supervisor_id number(10) constraint coaching_supervisor_fk references supervisor not null, 
c_comment varchar2(999),
supsignature varchar2(1) not null check (supsignature in('Y','N')));

create table disciplinary (
DA_No number(10) constraint disciplinary_pk primary key, 
d_Date date constraint disciplinary_date_null not null, 
Prob_date_time date not null, 
Problem_Des varchar2(999) not null, 
Improve_Req varchar2(999) not null, 
Improve_Date date not null, 
Emp_Comment varchar2(999) not null, 
Emp_Sig varchar2(1) check (Emp_Sig in('Y','N')), 
EMP_Sig_Date date, 
Superv_Sig varchar2(1) check (Superv_Sig in('Y','N')), 
Superv_Sig_Date date, 
Hr_Sig varchar2(1) check (Hr_sig in('Y','N')), 
Hr_Sig_date date, 
Caller_ID number(10) constraint disciplinary_caller_fk references caller not null, 
Supervisor_ID number(10) constraint disciplinary_supervosor_fk references supervisor not null, 
Action_Code varchar2(50) constraint disciplinary_actioncode_fk references action_taken,
Acknowledge varchar2(1) check (Acknowledge in('Y','N')));

CREATE INDEX dis_caller ON disciplinary (Caller_ID);

create table problem (
DA_No number(10) constraint problem_disciplinary_fk references disciplinary, 
Reason_code varchar2(50) constraint problem_action_fk references reason_for_action,
PRIMARY KEY (DA_No,Reason_code));

create table offer (
Interview_id number(10) constraint offer_interview_fk references interview primary key, 
offer_date date not null);

create table training_session (
train_id number(10) constraint train_pk primary key,  
Training_type varchar2(20) constraint ts_trainingtype_fk references training_type not null, 
Training_score number(1), 
Date_time date,
Evaluation varchar2(999), 
Signature varchar2(1) not null check (Signature in('Y','N')),
trainer_id number(10) constraint ts_supervisor_fk references supervisor not null, 
trainee_id number(10) constraint ts_caller_fk references caller not null,
Status_code varchar2(50) constraint ts_status_fk references status);

create table emp_schedule (
Person_ID number(10) constraint empschedule_person_fk references person, 
Day_id number(6) constraint empschedule_day_fk references day, 
Time_period_id varchar2(50) constraint empschedule_timeperiod_fk references timeperiod, 
Status_code varchar2(50) constraint empschedule_status_fk references status,
management_id number(10)constraint e_management_fk references management,
Primary key (Person_ID, Day_id, Time_period_id));

CREATE INDEX emp_schedule_timeslot ON emp_schedule (Day_id, Time_period_id);

CREATE CLUSTER gift_cluster (Gift_ID number(10));
CREATE INDEX gift_cluster_index on cluster gift_cluster;


create table Gift(
Gift_ID number(10) constraint gift_pk primary key,
amount number(6) not null,
call_id number(10) constraint gift_call references call)
cluster gift_cluster (Gift_ID);

CREATE INDEX gift_callid ON Gift (call_id);

create table Gift_Schedule(
Frequency varchar2(20) constraint gs_pk primary key,
description varchar2(999) not null);

create table Credit_Card(
Gift_ID number(10) constraint cc_gifttype_fk references gift primary key,
card_num varchar2(16) not null,
expire_date date not null,
billing_str varchar2(999) not null,
ZIP number(5) constraint billing_zip_fk references zip not null)
cluster gift_cluster (Gift_ID);

create table Pledge_Type(
Pledge_type varchar2(30) constraint pledgetype_pk primary key not null,
description varchar2(999) not null);

create table Pledge(
Gift_ID number(10) constraint pledge_gifttype_fk references gift primary key,
pledge_type varchar2(30) constraint pledge_pledgetype_fk references pledge_type not null,
mailing_add varchar2(999) not null,
ZIP number(5) constraint mailing_zip_fk references zip)
cluster gift_cluster (Gift_ID);

create table Recurring_Gift(
Gift_ID number(10) constraint rg_gifttype_fk references gift primary key,
frequency varchar2(20) constraint rg_giftschedule_fk references gift_schedule not null)
cluster gift_cluster (Gift_ID);

insert into major values ('ee','electrical engineering');
insert into major values ('ba','business administration');
insert into major values ('me','mechanical engineering');
insert into major values ('ce','computer engineering');
insert into major values ('cs','computer science');

insert into   reason_for_action values ('Performance Problem','have some problem on performance');
insert into   reason_for_action values ('Violation of Department Work Rule','violate the department work rule');
insert into   reason_for_action values ('Violation of Company Policy','violate the company policy');

insert into   action_taken values ('Verbal Warning','Warning Verbally');
insert into   action_taken values ('Written Warning','Warning on record');
insert into   action_taken values ('Suspension','stop the work for a while');
insert into   action_taken values ('Probation','work and see if one is sui  for further work');
insert into   action_taken values ('Probation Review 30 days','30 days review of probation');
insert into   action_taken values ('Probation Review 60 days',' 60 days review of probation');
insert into   action_taken values ('Probation Review 90 days',' 90 days review of probation');
insert into   action_taken values ('Termination','stop the contract with the employee');

insert into   training_type values ('group');
insert into   training_type values ('site');

insert into   department values ('ACC','Accounting');
insert into   department values ('BUS','Business');
insert into   department values ('ENG','Engineering');
insert into   department values ('CIN','Cinematic');
insert into   department values ('LSA','Letter Science and Arts');
insert into   department values ('ARC','Architecture');
insert into   department values ('DANC','Dance');

insert into   call_result values ('Answering Machine','voice message');
insert into   call_result values ('Not Available','not available');
insert into   call_result values ('Pledge','Promise to donate');
insert into   call_result values ('No Pledge','no promise to donate');
insert into   call_result values ('Call Back','call back');
insert into   call_result values ('Day Donor Call Back','Future donor who want to be called during day time');
insert into   call_result values ('Day Nondonor Call Back',' Future non-donor who want to be called during day time');
insert into   call_result values ('Evening Call',' people who want to be called during in the evening');
insert into   call_result values ('No English','do not speak English');
insert into   call_result values ('Spanish','speak Spanish');
insert into   call_result values ('Deceased','Deceased');
insert into   call_result values ('Do Not Call','do not call anymore');
insert into   call_result values ('Already Pledged','Already promise to donate');

insert into   donor_type values ('1ST LYB GRAD',' First time lybunts graduate students');
insert into   donor_type values ('1ST LYB UG FALL','First time lybunts fall enrolled undergraduate students');
insert into   donor_type values ('1ST LYB UG SPRING',' First time lybunts spring enrolled undergraduate students');
insert into   donor_type values ('FD TIER1',' Tier 1 Future Donors');
insert into   donor_type values ('FD TIER2',' Tier 2 Future Donors');
insert into   donor_type values ('OTHER DONOR UG',' Other donor undergraduate students');

Insert into Calling_pool values('ACC 1ST LYB GRAD', 'ACC', 'accounting first time lybunts graduate students', 2, 0.0010,0,0,0,0,0,0,0,0,0,0,0,0, '1ST LYB GRAD');
Insert into Calling_pool values('BUS 1ST LYB GRAD', 'BUS', 'business first time lybunts graduate students', 1, 0.0005, 0,0,0,0,0,0,0,0,0,0,0,0, '1ST LYB GRAD');
Insert into Calling_pool values('CIN 1ST LYB GRAD', 'CIN', 'cinematic first time lybunts graduate students', 1, 0.0005, 0,0,0,0,0,0,0,0,0,0,0,0, '1ST LYB GRAD');
Insert into Calling_pool values('BUS FD TIER2', 'BUS', 'business Tier 2 Future Donors', 4, 0.0020,4,1,0,0,0,0,0,0,0,0,0,0, 'FD TIER2');
Insert into Calling_pool values('DANC 1ST LYB UG FALL', 'DANC', 'dance first time lybunts fall enrolled undergraduate students', 11, 0.0054, 0,0,0,0,0,0,0,0,0,0,0,0, '1ST LYB UG FALL');
Insert into Calling_pool values('ENG OTHER DONOR UG', 'ENG', 'engineering Other donor undergraduate students', 3, 0.0015, 0,0,0,0,0,0,0,0,0,0,0,0, 'OTHER DONOR UG');
Insert into Calling_pool values('CIN 1ST LYB UG SPRING', 'CIN', 'cinematic first time lybunts spring enrolled undergraduate students', 30, 0.0146, 5, 0.1670, 4, 0.8000, 150, 100, 250, 50, 0.5000, 75, 125, 0.5000,'1ST LYB UG SPRING');

insert into   day values (161031,'10-31-16');
insert into   day values (161101,'11-01-16');
insert into   day values (161102,'11-02-16');
insert into   day values (161103,'11-03-16');
insert into   day values (161104,'11-04-16');
insert into   day values (161105,'11-05-16');
insert into   day values (161106,'11-06-16');

insert into   status values ('NCNS','no call no show');
insert into   status values ('RFDO','request for day off');
insert into   status values ('TARDY','tardy');
insert into   status values ('SENT HOME W/O PAY','sent home without pay');
insert into   status values ('UNEXCUSED RFDO','unexcused request for day off');
insert into   status values ('MAKE-UP SHIFT','make-up shift');
insert into   status values ('ALL GOOD','things went all goood');

insert into   timeperiod values ('2to4pm','2:00 - 4:00');
insert into   timeperiod values ('4to6pm','4:00 - 6:00');
insert into   timeperiod values ('6to8pm','6:00 - 8:00');

insert into   timeslot values (161031, '2to4pm',18);
insert into   timeslot values (161031, '4to6pm',15);
insert into   timeslot values (161031, '6to8pm',28);
insert into   timeslot values (161101, '2to4pm',21);
insert into   timeslot values (161101, '4to6pm',25);
insert into   timeslot values (161101, '6to8pm',16);
insert into   timeslot values (161102, '2to4pm',22);
insert into   timeslot values (161102, '4to6pm',26);
insert into   timeslot values (161102, '6to8pm',24);
insert into   timeslot values (161103, '2to4pm',19);
insert into   timeslot values (161103, '4to6pm',16);
insert into   timeslot values (161103, '6to8pm',15);
insert into   timeslot values (161104, '2to4pm',26);
insert into   timeslot values (161104, '4to6pm',24);
insert into   timeslot values (161104, '6to8pm',23);
insert into   timeslot values (161105, '2to4pm',17);
insert into   timeslot values (161105, '4to6pm',16);
insert into   timeslot values (161105, '6to8pm',21);
insert into   timeslot values (161106, '2to4pm',23);
insert into   timeslot values (161106, '4to6pm',22);
insert into   timeslot values (161106, '6to8pm',15);

insert into ZIP values (91803,'ALHAMBRA','CA');
insert into ZIP values (91104,'PASADENA','CA');
insert into ZIP values (90007,'LOS ANGELES','CA');
insert into ZIP values (51003,'ALTON','IA');
insert into ZIP values (10001,'NEW YORK','NY');
insert into ZIP values (60610,'CHICAGO','IL');
insert into ZIP values (75201,'DALLAS','TX');
insert into ZIP values (75041,'GARLAND','TX');
insert into ZIP values (60501,'SUMMIT ARGO','IL');
insert into ZIP values (49854,'MANISTIQUE','MI');
insert into ZIP values (12345,'SCHENECTADY','NY');
insert into ZIP values (67801,'DODGE CITY','KS');

insert into   score values ('1',' Bad/Missing');
insert into   score values ('2',' Below Average');
insert into   score values ('3',' Average');
insert into   score values ('4','Great');
insert into   score values ('5','Perfect');

insert into matching_company values (7645684536,'KPMG','1:1');
insert into matching_company values (7466312643,'EY','1:1');
insert into matching_company values (3129864632,'Deloitte','1:1');
insert into matching_company values (3164531613,'PwC','1:1');
insert into matching_company values (9747316325,'Amazon','1:1');
insert into matching_company values (9674496332,'Google','1:1');
insert into matching_company values (9461261361,'NASA','1:1');
insert into matching_company values (5626562384,'Boeing','1:1');

/*manager*/
insert into person values (7778596423,'Kanye','West','08-08-68',895647286,2135698746,'kanyewest@gmail.com','fake st',91803,'');
/*supervisor*/
insert into person values (7946851351,'kha','zix','05-06-88',452361256,7845213659,'jungleassassin@gmail.com','void st',91803,'');
insert into person values (7984658123,'tahm','kench','07-23-82',452615986,3201548796,'supportbigstomache@hotmail.com','eateateat ave',91803,'');
insert into person values (7984123879,'vel','koz','06-20-74',451268795,2135026403,'bigeye@yahoo.com','puzz blvd',91803,'');
insert into person values (9784631586,'twisted','fate','03-30-90',986523415,4512365902,'cometomycasino@lol.com','itsmyluckyday rd',91803,'');
insert into person values (9784521395,'rek','sai','02-27-79',784526953,4875965321,'digdigdig@bing.com','miner pl',91803,'');
insert into person values (7845874963,'xin','zhao','03-31-92',321026503,4785965321,'wannaaanal@demacia.com','demacia sq',91803,'');
/*caller*/
insert into person values (8459685423,'kosaka','honoka','05-12-94',462458653,4526485946,'honokak@yahoo.com','memphis ave',91104,'ee');
insert into person values (7459874632,'ayase','eri','05-30-96',784526594,9603206542,'eria@yahoo.com','thebes ave',91104,'ee');
insert into person values (2636798452,'minami','kotori','04-28-95',587964523,6659845532,'kotorim@yahoo.com','jerusalem st',91104,'ee');
insert into person values (2639874562,'sonoda','umi','01-25-93',458497513,6542156875,'umis@hotmail.com','macedonia st',91104,'ee');
insert into person values (4875964132,'hoshizora','rin','02-22-88',635425168,3200154688,'rinh@gmail.com','armenia st',91104,'ee');
insert into person values (6589745235,'nishikino','maki','03-12-92 ',459785632,4320123002,'makin@hotmail.com','antioch rd',90007,'me');
insert into person values (8794582365,'tojo','nozomi','03-10-89',213659785,3356984751,'nozomit@hotmail.com','athens blvd',90007,'me');
insert into person values (9785463245,'koizumi','hanayo','11-29-96',548796532,5468512235,'hanayok@gmail.com','changan ave',90007,'me');
insert into person values (9856974323,'yazawa','niko','02-22-91',564895614,3154687952,'nikoy@hotmail.com','xiangyang blvd',90007,'me');
insert into person values (6554633453,'takami','chika','12-31-92',256484521,1223654798,'chikat@yahoo.com','vatican st',90007,'me');
insert into person values (6453635621,'sakurauchi','riko','11-11-93',546945132,5487965412,'rikos@hotmail.com','venece ave',90007,'ce');
insert into person values (6952969338,'matsuura','kanan','10-30-91',658945261,3215468556,'kananm@bing.com','rome blvd',90007,'ce');
insert into person values (6854365263,'kurosawa','daiya','04-30-91',546879132,5564875623,'daiyak@yahoo.com','beijing ave',51003,'ce');
insert into person values (6845356523,'watanabe','yo','07-09-95',978461325,2135486215,'yow@gmail.com','jakarta blvd',51003,'ce');
insert into person values (4563526533,'tsushima','yoshiko','04-22-92',543547895,3215468795,'yoshikot@hotmail.com','ur ave',51003,'ce');
insert into person values (6895265263,'kunikida','hanamaru','02-12-93',693521679,5566320015,'hanamaruk@yahoo.com','babylon st',51003,'cs');
insert into person values (6856263596,'ohara','mari','01-10-93',984632105,3154487965,'mario@gmail.com','alexandria blvd',51003,'cs');
insert into person values (6899562613,'kurosawa','rubi','06-18-95',329501602,4652315468,'rubik@yahoo.com','damascus ave',51003,'cs');
insert into person values (6243268669,'miura','azusa','08-11-95',200111548,4523154682,'azusam@bing.com','tripoli blvd',10001,'cs');
insert into person values (9233854625,'jougasaki','rikka','01-20-91',302154879,6423165486,'rikkaj@yahoo.com','cathage ave',10001,'ba');

/*prospect*/

insert into person values (8327232535,'jone','cena','05-01-87',794526482,8795842648,'cenajohn@gmail.com','wilshire st',10001,'');
insert into person values (6285256663,'joseph','gobbels','04-21-86',978478496,7849581265,'josephgob@gmail.com','vermont ave',60610,'');
insert into person values (3524682453,'issac','newton','01-20-91',236548127,7569485165,'physics@bing.com','hoover st',60610,'');
insert into person values (3425245662,'jesus','christ','12-25-76',948123795,4879651356,'imthegoooood@hotmail.com','pico st',60610,'');
insert into person values (3543323333,'osama','bin laden','03-06-65',658423956,7845984526,'imnotisis@gmail.com','san marino ave',75201,'');
insert into person values (3653635689,'shirazuka','shizuka','02-05-91',254869512,7845269548,'oreno@gmail.com','washington ave',75201,'');
insert into person values (6824635169,'hikigaya','hachiman','05-03-88',794825692,8945268459,'seishyun@gmail.com','olympic ave',75201,'');
insert into person values (6263526533,'yukinoshita','yukino','04-29-66',978436598,259874635,'rabukomi@usc.edu','jefferson st',75041,'');
insert into person values (6254526542,'yugahama','yui','01-07-92',658425968,8745269584,'wamachiga@gmail.com','3rd st',75041,'');
insert into person values (6842362648,'ishiki','iroha','06-06-61',478123596,8745269678,'teiru@gmail.com','mcclintock rd',75041,'');
insert into person values (6726235656,'heinz','guderian','04-27-83',548712596,7845236594,'panzervon@bing.com','leavy st',60501,'');
insert into person values (6826259625,'charles','de gaulle','03-22-74',236984257,7812369847,'fraaancebitches@gmail.com','sylley rd',60501,'');
insert into person values (6546451365,'suzumiya','haruhi','05-04-81',874565984,4568956423,'youyu@gmail.com','minnesoda rd',60501,'');
insert into person values (3115622653,'kyon','kun','01-03-76',794512863,8745213659,'facelessman@gmail.com','nevada st',49854,'');
insert into person values (8962466233,'ballistic','missle','12-02-77',359248156,8754695842,'icbm@@hotmail.com','idaho ave',49854,'');
insert into person values (6236235653,'oi','ocha','05-03-65',246851395,8752365942,'itoenocha@bing.com','15th st',49854,'');
insert into person values (6262356236,'linkin','park','07-11-91',978452168,8452695875,'numb@hotmail.com','jones st',12345,'');
insert into person values (6325351236,'flying','spagetti','12-01-88',978465238,8474523659,'believeinme@gmail.com','201st rd',12345,'');
insert into person values (2514354333,'indiana','jones','11-07-72',845291673,8745236598,'thisbelongsinthemsm@gmail.com','university st',12345,'');
insert into person values (6362566335,'yogg','saaron','02-02-70',597654812,8451326958,'hearthstone@hotmail.com','church st',67801,'');

/*spouse*/ 
insert into person values (3103131679,'kalista','thresh','07-05-94',643651538,6941326545,'counterlogic@bing.com','minnesoda st',67801,'');
insert into person values (6823435437,'udyr','nocturne','10-10-82',784596231,1354617956,'omggaming@gmail.com','kingsrole st',67801,'');
insert into person values (4673654631,'alistar','ahri','12-27-79',817445645,8461364697,'royalclub@gmail.com','el dorado st',67801,'');
insert into person values (9465163154,'miss','fortune','04-29-68',147635325,1641331688,'cloudnine@hotmail.com','hanamura st',67801,'');
insert into person values (6872524648,'double','lyft','06-30-91',687426465,9746619686,'clg@hotmail.com','summoner st',67801,'');
insert into person values (6181764974,'faker','froggen','05-31-88',794664315,1654596319,'rng@bing.com','rift st',67801,'');
insert into person values (8687864658,'dyrus','bjergsen','11-02-85',987632168,8463136597,'edwardg@bing.com','howling st',60610,'');
insert into person values (6746512612,'lemon','nation','07-17-86',976621641,6143644699,'snake@gmail.com','abyss st',60610,'');
insert into person values (6782246964,'bunny','fufu','01-08-89',641694263,7641631235,'qgaming@gmail.com','twisted st',60610,'');
insert into person values (6124656468,'sneaky','meteos','01-19-81',365263165,3416946495,'immortals@gmail.com','treeline st',60610,'');

insert into management values (7778596423);
insert into management values (7946851351);
insert into management values (7984658123);
insert into management values (7984123879);
insert into management values (9784631586);
insert into management values (9784521395);
insert into management values (7845874963);

insert into manager values (7778596423);

insert into supervisor values (7946851351);
insert into supervisor values (7984658123);
insert into supervisor values (7984123879);
insert into supervisor values (9784631586);
insert into supervisor values (9784521395);
insert into supervisor values (7845874963);

insert into applicant values (8459685423,2017);
insert into applicant values (7459874632,2020);
insert into applicant values (2636798452,2018);
insert into applicant values (2639874562,2019);
insert into applicant values (4875964132,2017);
insert into applicant values (6589745235,2018);
insert into applicant values (8794582365,2017);
insert into applicant values (9785463245,2019);
insert into applicant values (9856974323,2020);
insert into applicant values (6554633453,2018);
insert into applicant values (6453635621,2017);
insert into applicant values (6952969338,2019);
insert into applicant values (6854365263,2018);
insert into applicant values (6845356523,2017);
insert into applicant values (4563526533,2018);
insert into applicant values (6895265263,2017);
insert into applicant values (6856263596,2018);
insert into applicant values (6899562613,2018);
insert into applicant values (6243268669,2017);
insert into applicant values (9233854625,2018);

insert into interview values (2016081901, 7778596423, 8459685423, '08-19-16');
insert into interview values (2016081902, 7778596423, 7459874632, '08-19-16');
insert into interview values (2016081903, 7778596423, 2636798452, '08-19-16');
insert into interview values (2016081904, 7778596423, 2639874562, '08-19-16');
insert into interview values (2016081905, 7778596423, 4875964132, '08-19-16');
insert into interview values (2016081906, 7778596423, 6589745235, '08-19-16');
insert into interview values (2016082101, 7778596423, 8794582365, '08-21-16');
insert into interview values (2016082102, 7778596423, 9785463245, '08-21-16');
insert into interview values (2016082103, 7778596423, 9856974323, '08-21-16');
insert into interview values (2016082104, 7778596423, 6554633453, '08-21-16');
insert into interview values (2016082105, 7778596423, 6453635621, '08-21-16');
insert into interview values (2016082106, 7778596423, 6952969338, '08-21-16');
insert into interview values (2016082107, 7778596423, 6854365263, '08-21-16');
insert into interview values (2016082108, 7778596423, 6845356523, '08-21-16');
insert into interview values (2016082109, 7778596423, 4563526533, '08-21-16');
insert into interview values (2016082204, 7778596423, 6895265263, '08-22-16');
insert into interview values (2016082205, 7778596423, 6856263596, '08-22-16');
insert into interview values (2016082206, 7778596423, 6899562613, '08-22-16');
insert into interview values (2016082207, 7778596423, 6243268669, '08-22-16');
insert into interview values (2016082208, 7778596423, 9233854625, '08-22-16');

insert into caller values (8459685423,4.1,3.6,5.0,2.2,3.7,3.7,454,6521,10,45,0,0,1,0,1,0,4.1,4.9,4.2,4.6,4.9,2016081901);
insert into caller values (7459874632,3.7,5.0,2.9,4.2,4.3,4.7,653,5948,15,46,0,0,0,0,0,2,3.8,3.9,4.2,4.6,4.5,2016081902);
insert into caller values (2636798452,4.5,4.3,4.9,4.8,4.5,4.6,665,23509,15,55,1,2,0,0,0,0,4.5,4.6,3.9,4.1,4.2,2016081903);
insert into caller values (2639874562,4.5,4.5,3.8,5.0,4.7,4.1,978,32077,25,60,0,0,2,0,0,0,4.5,4.4,3.9,3.2,4.9,2016081904);
insert into caller values (4875964132,3.6,4.5,2.9,3.5,4.8,4.9,556,6598,10,71,0,1,0,0,0,5,3.9,4.2,4.5,3.9,4.9,2016081905);
insert into caller values (6589745235,4.9,4.8,4.9,5.0,4.6,4.3,332,9845,13,26,2,0,0,2,2,4,4.2,4.3,4.6,4.6,4.2,2016081906);
insert into caller values (8794582365,5.0,5.0,3.9,4.9,4.8,4.8,651,9485,20,35,0,1,0,0,0,0,3.9,4.6,4.5,4.8,4.7,2016082101);
insert into caller values (9785463245,4.6,4.6,5.0,2.9,1.1,3.6,955,1206,27,41,0,2,0,0,0,0,4.7,4.1,4.5,4.6,4.1,2016082102);
insert into caller values (9856974323,4.5,4.5,4.8,4.8,4.9,4.6,860,9563,12,46,5,0,9,0,0,3,4.2,4.5,4.4,4.8,3.7,2016082103);
insert into caller values (6554633453,4.5,4.5,4.6,3.5,3.7,5.0,621,8025,13,50,1,0,0,0,1,0,4.6,4.5,4.8,4.0,4.2,2016082104);
insert into caller values (6453635621,4.5,4.6,4.3,4.8,4.7,4.9,547,6520,10,58,0,3,2,0,0,2,4.1,4.2,4.4,4.5,4.6,2016082105);
insert into caller values (6952969338,4.5,4.5,4.6,4.6,4.3,4.5,845,32500,19,43,0,7,0,0,0,1,4.5,4.2,4.0,4.0,3.9,2016082106);
insert into caller values (6854365263,3.6,3.5,3.2,2.9,4.9,4.0,652,4526,14,29,0,2,0,0,0,5,4.5,4.6,4.3,4.3,4.8,2016082107);
insert into caller values (6845356523,2.5,2.4,2.6,4.5,3.1,5.0,632,8523,15,60,0,3,3,0,3,5,4.1,4.2,4.6,4.9,4.5,2016082108);
insert into caller values (4563526533,5.0,5.0,4.9,4.8,5.0,5.0,952,3021,21,51,1,0,0,0,0,0,4.1,4.1,4.0,4.3,4.8,2016082109);
insert into caller values (6895265263,3.9,3.8,4.5,4.6,4.4,4.6,945,6512,22,49,0,1,0,0,0,2,4.6,4.5,4.3,4.1,4.2,2016082204);
insert into caller values (6856263596,3.9,3.8,5.0,2.9,1.1,5.0,620,10028,12,48,2,0,1,1,1,0,4.5,4.6,4.8,4.2,4.6,2016082205);
insert into caller values (6899562613,4.6,4.6,4.5,4.9,5.0,3.9,684,4862,16,56,0,0,0,0,0,3,4.7,4.8,4.8,4.9,4.5,2016082206);
insert into caller values (6243268669,4.6,4.6,5.0,4.2,4.1,4.7,645,32064,15,43,0,0,0,1,0,0,4.6,4.5,4.2,4.1,4.3,2016082207);
insert into caller values (9233854625,5.0,5.0,4.9,4.9,4.7,4.8,857,8452,19,44,0,3,0,0,0,0,4.8,4.1,4.5,4.6,4.3,2016082208);

insert into spouse values (3103131679);
insert into spouse values (6823435437);
insert into spouse values (4673654631);
insert into spouse values (9465163154);
insert into spouse values (6872524648);
insert into spouse values (6181764974);
insert into spouse values (8687864658);
insert into spouse values (6746512612);
insert into spouse values (6782246964);
insert into spouse values (6124656468);

alter session set nls_date_format='mm-dd-yy';

insert into prospect values (8327232535,'ACC 1ST LYB GRAD','mr','05-30-10','marshall','banchelor','universitypark',3103131679);
insert into prospect values (6285256663,'ACC 1ST LYB GRAD','ms','12-30-09','viterbi','PHD','universitypark',6823435437);
insert into prospect values (3524682453,'ACC 1ST LYB GRAD','mrs','12-30-07','dornsife','PHD','universitypark',4673654631);
insert into prospect values (3425245662,'ACC 1ST LYB GRAD','mr','05-30-10','young','master','universitypark',9465163154);
insert into prospect values (3543323333,'ACC 1ST LYB GRAD','mr','05-30-10','roski','banchelor','universitypark',6872524648);
insert into prospect values (3653635689,'BUS 1ST LYB GRAD','mr','12-30-13','marshall','banchelor','universitypark',6181764974);
insert into prospect values (6824635169,'BUS 1ST LYB GRAD','mrs','05-30-12','viterbi','PHD','universitypark',8687864658);
insert into prospect values (6263526533,'BUS 1ST LYB GRAD','mrs','05-30-12','marshall','banchelor','universitypark',6746512612);
insert into prospect values (6254526542,'BUS 1ST LYB GRAD','mr','12-30-10','dornsife','PHD','universitypark',6782246964);
insert into prospect values (6842362648,'BUS 1ST LYB GRAD','mr','05-30-09','viterbi','banchelor','universitypark',6124656468);
insert into prospect values (6726235656,'CIN 1ST LYB GRAD','ms','05-30-09','dornsife','master','universitypark','');
insert into prospect values (6826259625,'CIN 1ST LYB GRAD','mrs','05-30-15','roski','banchelor','universitypark','');
insert into prospect values (6546451365,'CIN 1ST LYB GRAD','ms','12-30-14','viterbi','PHD','universitypark','');
insert into prospect values (3115622653,'CIN 1ST LYB GRAD','mrs','12-30-02','young','banchelor','universitypark','');
insert into prospect values (8962466233,'CIN 1ST LYB GRAD','mr','05-30-03','dornsife','master','universitypark','');
insert into prospect values (6236235653,'DANC 1ST LYB UG FALL','mr','05-30-10','viterbi','master','universitypark','');
insert into prospect values (6262356236,'DANC 1ST LYB UG FALL','ms','12-30-10','marshall','banchelor','universitypark','');
insert into prospect values (6325351236,'DANC 1ST LYB UG FALL','ms','12-30-08','viterbi','master','universitypark','');
insert into prospect values (2514354333,'DANC 1ST LYB UG FALL','mr','12-30-11','roski','banchelor','universitypark','');
insert into prospect values (6362566335,'DANC 1ST LYB UG FALL','mr','05-30-13','viterbi','banchelor','universitypark','');

insert into Prospect_matching values (7645684536,8327232535);
insert into Prospect_matching values (3129864632,6285256663);
insert into Prospect_matching values (9461261361,3524682453);
insert into Prospect_matching values (3129864632,3425245662);
insert into Prospect_matching values (9674496332,3543323333);
insert into Prospect_matching values (7466312643,3653635689);
insert into Prospect_matching values (7645684536,6824635169);
insert into Prospect_matching values (9461261361,6263526533);
insert into Prospect_matching values (7466312643,6254526542);
insert into Prospect_matching values (5626562384,6842362648);
insert into Prospect_matching values (9747316325,6726235656);
insert into Prospect_matching values (7466312643,6826259625);
insert into Prospect_matching values (3129864632,6546451365);
insert into Prospect_matching values (9747316325,3115622653);
insert into Prospect_matching values (3164531613,8962466233);
insert into Prospect_matching values (7645684536,6236235653);
insert into Prospect_matching values (3164531613,6262356236);
insert into Prospect_matching values (5626562384,6325351236);
insert into Prospect_matching values (9674496332,2514354333);
insert into Prospect_matching values (3164531613,6362566335);

alter session set nls_date_format='mm-dd-yy hh24:mi';

Insert into Call values (56369856,2636798452, 8327232535, 'Answering Machine','10-14-16 14:23','Y','Y',20,'11-25-16',20);
Insert into Call values (54862126,6895265263, 6285256663, 'Not Available','10-15-16 14:26','Y','Y',50,'11-25-16',50);
Insert into Call values (74125874,6453635621, 3524682453, 'Pledge','10-15-16 15:23','Y','Y',60,'10-21-16',60);
Insert into Call values (41256985,4563526533, 3425245662, 'No Pledge','10-15-16 16:53','Y','N',20,'10-30-16',20);
Insert into Call values (42632148,6453635621, 3543323333, 'Deceased','10-15-16 17:23','Y','N',30,'10-21-16',30);
Insert into Call values (56521586,9856974323, 6824635169, 'Pledge','10-16-16 14:11','N','Y',5,'11-25-16',5);
Insert into Call values (65215862,2636798452, 6726235656, 'Do Not Call','10-17-16 17:32','N','Y',1,'10-27-16',1);
Insert into Call values (56685221,4563526533, 6826259625, 'Already Pledged', '10-17-16 19:45','N','N',10,'11-25-16',10);
Insert into Call values (47865212, 9856974323, 6262356236, 'No Pledge', '10-18-16 12:43','N','Y',15,'10-29-16',15);
Insert into Call values (56549652,6453635621, 2514354333, 'No Pledge', '10-18-16 14:23','N','N',10,'11-25-16',10);

Insert into coaching values (56369856,'Y','Y','Y','a good discussion about our school and campus',203,'Y','well done, keep it up mate!','asked about lives in usc and donation will','maybe be more confident when asking','Y','N','Y','Y','N','Y','Y',5,5,5,5,7946851351,'good job','Y');
Insert into coaching values (54862126,'Y','Y','Y','a good discussion about our school and campus',177,'Y','well done, keep it up mate!','asked about lives in usc and donation will','all questions are legitimate','Y','Y','Y','Y','Y','Y','Y',5,5,5,4,7946851351,'i like this one','Y');
Insert into coaching values (74125874,'Y','Y','Y','a good discussion about our school and campus',165,'Y','well done, keep it up mate!','asked about lives in usc and donation will','maybe be more confident when asking','Y','Y','N','Y','Y','Y','Y',5,5,5,5,7946851351,'nice one','Y');
Insert into coaching values (41256985,'Y','Y','Y','a good discussion about our school and campus',245,'Y','well done, keep it up mate!','asked about lives in usc and donation will','all questions are legitimate','Y','Y','Y','Y','Y','Y','N',5,5,4,5,7946851351,'well done','Y');
Insert into coaching values (42632148,'Y','Y','Y','a good discussion about our school and campus',220,'Y','well done, keep it up mate!','asked about lives in usc and donation will','maybe be more confident when asking','Y','N','Y','Y','Y','Y','Y',5,5,4,5,7946851351,'keep it','Y');
Insert into coaching values (56521586,'Y','Y','Y','a good discussion about our school and campus',178,'Y','well done, keep it up mate!','asked about lives in usc and donation will','all questions are legitimate','N','Y','Y','Y','Y','Y','Y',5,4,5,5,7984658123,'just fine','Y');
Insert into coaching values (65215862,'Y','N','Y','a good discussion about our school and campus',150,'Y','well done, keep it up mate!','asked about lives in usc and donation will','maybe be more confident when asking','Y','N','Y','N','Y','Y','Y',5,5,4,5,7984658123,'still good','Y');
Insert into coaching values (56685221,'Y','Y','N','a good discussion about our school and campus',142,'Y','well done, keep it up mate!','asked about lives in usc and donation will','all questions are legitimate','Y','Y','Y','Y','Y','Y','Y',5,5,5,5,7984658123,'so so','Y');
Insert into coaching values (47865212,'Y','Y','Y','a good discussion about our school and campus',256,'Y','well done, keep it up mate!','asked about lives in usc and donation will','maybe be more confident when asking','Y','Y','N','Y','Y','Y','Y',4,5,5,5,7984658123,'nice job','Y');
Insert into coaching values (56549652,'N','Y','Y','a good discussion about our school and campus',258,'Y','well done, keep it up mate!','asked about lives in usc and donation will','all questions are legitimate','Y','Y','N','Y','Y','Y','Y',5,5,5,5,7984658123,'well done','Y');

Insert into Disciplinary values (1237845651,'10-21-16 00:00','10-21-16 14:25',' was caught using cell phone during shift', 'If caught using phone second time will be put on probation',' 10-21-16 00:00','using phone will reduce performance','Y',' 10-21-16 00:00','Y', '10-21-16 00:00','Y', '10-21-16 00:00', 2636798452, 7845874963, 'Verbal Warning','Y');
Insert into Disciplinary values (1257845261,'10-24-16 00:00','10-24-16 16:35',' was caught using cell phone during shift', 'If caught using phone second time will be put on probation',' 10-24-16 00:00','using phone will reduce performance','Y',' 10-24-16 00:00','Y', '10-24-16 00:00','Y', ' 10-24-16 00:00', 8794582365, 7845874963, 'Verbal Warning','Y');
Insert into Disciplinary values (1267845265,'10-25-16 00:00','10-25-16 16:15',' late for 15mins', 'if this happens another 3 time will be put on probation','10-25-16 00:00','tardy is not good','Y',' 10-25-16 00:00','Y', '10-25-16 00:00','Y', '10-25-16 00:00', 8794582365, 9784521395, 'Verbal Warning','Y');
Insert into Disciplinary values (1273167942,'11-02-16 00:00','11-02-16 14:20',' late for 20mins', 'if this happens another 3 time will be put on probation','11-02-16 00:00','tardy is not good','Y',' 11-02-16 00:00','Y', '11-02-16 00:00','Y', '11-02-16 00:00', 8794582365, 7845874963, 'Verbal Warning' ,'Y');
Insert into Disciplinary values (1299874665,'11-08-16 00:00','11-08-16 18:10',' late for 10mins', 'this is the third time being late will be put on probation','11-10-16 00:00','tardy is not good','Y',' 11-08-16 00:00','Y', '11-08-16 00:00','Y', '11-08-16 00:00', 8794582365, 7845874963, 'Probation','Y');
Insert into Disciplinary values (1309874658,'11-11-16 00:00','11-11-16 14:30',' late for 30mins', 'forth time being late','11-11-16 00:00','tardy is not good','Y',' 11-11-16 00:00','Y', '11-11-16 00:00','Y', '11-11-16 00:00', 8794582365, 7984658123, 'Suspension','Y');
Insert into Disciplinary values (1329874642,'11-21-16 00:00','11-21-16 18:40',' sakurauchi, matsuura, kurosawa, watanabe were chatting in the restroom for 15 min during shift', 'Do not use restroom at same time for more than 10 minutes','11-02-16 00:00','no more chatting during shift','Y',' 11-21-16 00:00','Y', '11-21-16 00:00','Y', '11-21-16 00:00', 6453635621, 7984123879, 'Verbal Warning','Y');
Insert into Disciplinary values (1337854446,'11-21-16 00:00','11-21-16 18:40',' sakurauchi, matsuura, kurosawa, watanabe were chatting in the restroom for 15 min during shift', 'Do not use restroom at same time for more than 10 minutes','11-02-16 00:00','no more chatting during shift','Y',' 11-21-16 00:00','Y', '11-21-16 00:00','Y', '11-21-16 00:00', 6952969338, 7984123879, 'Verbal Warning','Y');
Insert into Disciplinary values (1344656625,'11-21-16 00:00','11-21-16 18:40',' sakurauchi, matsuura, kurosawa, watanabe were chatting in the restroom for 15 min during shift', 'Do not use restroom at same time for more than 10 minutes','11-02-16 00:00','no more chatting during shift','Y',' 11-21-16 00:00','Y', '11-21-16 00:00','Y', '11-21-16 00:00', 6854365263, 7984123879, 'Verbal Warning','Y');
Insert into Disciplinary values (1357456657,'11-21-16 00:00','11-21-16 18:40',' sakurauchi, matsuura, kurosawa, watanabe were chatting in the restroom for 15 min during shift', 'Do not use restroom at same time for more than 10 minutes','11-02-16 00:00','no more chatting during shift','Y',' 11-21-16 00:00','Y', '11-21-16 00:00','Y', '11-21-16 00:00', 6845356523, 7984123879, 'Verbal Warning','Y');

Insert into problem values (1237845651, 'Performance Problem');
Insert into problem values (1257845261, 'Performance Problem');
Insert into problem values (1267845265, 'Violation of Company Policy');
Insert into problem values (1273167942, 'Violation of Company Policy');
Insert into problem values (1299874665, 'Violation of Company Policy');
Insert into problem values (1309874658, 'Violation of Company Policy');
Insert into problem values (1329874642, 'Violation of Department Work Rule');
Insert into problem values (1337854446, 'Violation of Department Work Rule');
Insert into problem values (1344656625, 'Violation of Department Work Rule');
Insert into problem values (1357456657, 'Violation of Department Work Rule');

insert into offer values (2016081901, '08-24-16');
insert into offer values (2016081903, '08-24-16');
insert into offer values (2016081904, '08-24-16');
insert into offer values (2016081905, '08-24-16');
insert into offer values (2016081906, '08-24-16');
insert into offer values (2016082101, '08-27-16');
insert into offer values (2016082102, '08-27-16');
insert into offer values (2016082104, '08-27-16');
insert into offer values (2016082105, '08-27-16');
insert into offer values (2016082106, '08-27-16');

Insert into training_session values (7856789564, 'group',5,'08-22-16','Completed','Y', 7984123879, 8459685423,'ALL GOOD');
Insert into training_session values (2963652345, 'group',4,'08-22-16', 'Completed','Y', 7984123879, 7459874632,'ALL GOOD');
Insert into training_session values (4158689754, 'site',4, '08-29-16', 'Completed', 'Y', 7984123879, 2636798452,'ALL GOOD');
Insert into training_session values (1586658796, 'group',4, '08-22-16', 'Completed', 'Y', 7984123879, 2639874562,'ALL GOOD');
Insert into training_session values (8653785675, 'group',3, '08-22-16', 'Completed', 'Y', 9784631586, 4875964132,'ALL GOOD');
Insert into training_session values (6543685754, 'site',4, '08-29-16', 'Completed', 'Y', 9784631586, 6589745235,'ALL GOOD');
Insert into training_session values (1549798565, 'site',5, '08-24-16', 'Completed', 'Y', 9784631586, 8794582365,'ALL GOOD');
Insert into training_session values (7416896754, 'group',4, '08-22-16', 'Completed', 'Y', 7845874963, 9785463245,'ALL GOOD');
Insert into training_session values (7186789657, 'group',4, '08-22-16', 'Completed', 'Y', 7845874963, 9856974323,'ALL GOOD');
Insert into training_session values (5416125563, 'site',3, '08-27-16', 'Completed', 'Y', 7845874963, 6554633453,'ALL GOOD');

insert into Emp_Schedule values (8459685423, 161031, '2to4pm', 'NCNS',7778596423);
insert into Emp_Schedule values (7459874632, 161031, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (2636798452, 161031, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (2639874562, 161031, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (4875964132, 161031, '2to4pm', 'TARDY',7778596423);
insert into Emp_Schedule values (6589745235, 161031, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (8794582365, 161031, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (9785463245, 161031, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (9856974323, 161031, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6554633453, 161031, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6453635621, 161031, '2to4pm', 'NCNS',7778596423);
insert into Emp_Schedule values (6952969338, 161031, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6854365263, 161031, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6845356523, 161031, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (4563526533, 161031, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6895265263, 161101, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6856263596, 161101, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6899562613, 161101, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6243268669, 161101, '6to8pm', 'RFDO',7778596423);
insert into Emp_Schedule values (9233854625, 161101, '6to8pm', 'ALL GOOD',7778596423);

insert into Emp_Schedule values (8459685423, 161101, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (7459874632, 161101, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (2636798452, 161101, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (2639874562, 161101, '2to4pm', 'TARDY',7778596423);
insert into Emp_Schedule values (4875964132, 161101, '2to4pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6589745235, 161102, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (8794582365, 161102, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (9785463245, 161102, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (9856974323, 161102, '6to8pm', 'SENT HOME W/O PAY',7778596423);
insert into Emp_Schedule values (6554633453, 161102, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6453635621, 161102, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6952969338, 161102, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6854365263, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6845356523, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (4563526533, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6895265263, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6856263596, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6899562613, 161104, '4to6pm', 'TARDY',7778596423);
insert into Emp_Schedule values (6243268669, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (9233854625, 161104, '4to6pm', 'ALL GOOD',7778596423);

insert into Emp_Schedule values (8459685423, 161104, '4to6pm', 'MAKE-UP SHIFT',7778596423);
insert into Emp_Schedule values (7459874632, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (2636798452, 161104, '4to6pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (2639874562, 161105, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (4875964132, 161105, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6589745235, 161105, '6to8pm', 'RFDO',7778596423);
insert into Emp_Schedule values (8794582365, 161105, '6to8pm', 'NCNS',7778596423);
insert into Emp_Schedule values (9785463245, 161105, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (9856974323, 161105, '6to8pm', 'ALL GOOD',7778596423);
insert into Emp_Schedule values (6554633453, 161105, '6to8pm', 'ALL GOOD',7778596423);

insert into gift values (7964511568,20,56369856);
insert into gift values (7796547913,50,54862126);
insert into gift values (9784213596,10,74125874);
insert into gift values (4787956482,1,41256985);
insert into gift values (6998754685,20,42632148);
insert into gift values (3265148551,20,56521586);
insert into gift values (2003154698,100,65215862);
insert into gift values (4562345698,30,56685221);
insert into gift values (9986554213,2000,47865212);
insert into gift values (1236582235,10,56549652);

insert into gift_schedule values ('weekly','donate every Monday');
insert into gift_schedule values ('2-weekly','donate every other Monday');
insert into gift_schedule values ('monthly','donate on 1st of every month');
insert into gift_schedule values ('half-yearly','donate every other 1st of month');
insert into gift_schedule values ('yearly','donate every January 1st');

insert into credit_card values (7964511568,'9156842563154875','08-20-29','wilshire st',10001);
insert into credit_card values (7796547913,'9785468213654278','04-27-18','vermont ave',60610);
insert into credit_card values (9784213596,'7854226589745165','10-01-23','hoover st',60610);
insert into credit_card values (4787956482,'7784526584523659','12-03-17','pico st',60610);
insert into credit_card values (6998754685,'7984788854168463','08-05-18','san marino ave',75201);
insert into credit_card values (3265148551,'7984521365516795','04-11-19','washington ave',75201);
insert into credit_card values (2003154698,'7946361356363563','06-20-18','olympic ave',75201);
insert into credit_card values (4562345698,'6587171757486746','07-27-22','jefferson st',75041);
insert into credit_card values (9986554213,'5187423658576456','08-27-18','3rd st',75041);
insert into credit_card values (1236582235,'1681672363653653','11-28-17','mcclintock rd',75041);

insert into pledge_type values ('physical','deliver bill to mailbox');
insert into pledge_type values ('electrical','send bill via email');

insert into pledge values (7964511568,'physical','wilshire st',10001);
insert into pledge values (7796547913,'electrical','personalemail','');
insert into pledge values (9784213596,'electrical','personalemail','');
insert into pledge values (4787956482,'electrical','personalemail','');
insert into pledge values (6998754685,'electrical','personalemail','');
insert into pledge values (3265148551,'physical','olympic ave',75201);
insert into pledge values (2003154698,'electrical','personalemail','');
insert into pledge values (4562345698,'electrical','personalemail','');
insert into pledge values (9986554213,'electrical','personalemail','');
insert into pledge values (1236582235,'electrical','personalemail','');

insert into recurring_gift values (7964511568,'weekly');
insert into recurring_gift values (7796547913,'weekly');
insert into recurring_gift values (9784213596,'weekly');
insert into recurring_gift values (4787956482,'weekly');
insert into recurring_gift values (6998754685,'weekly');
insert into recurring_gift values (3265148551,'monthly');
insert into recurring_gift values (2003154698,'monthly');
insert into recurring_gift values (4562345698,'monthly');
insert into recurring_gift values (9986554213,'monthly');
insert into recurring_gift values (1236582235,'monthly');

select * from recurring_gift;
select * from pledge;
select * from pledge_type;
select * from credit_card;
select * from gift_schedule;
select * from gift;
select * from emp_schedule;
select * from training_session;
select * from offer;
select * from problem;
select * from disciplinary;
select * from coaching;
select * from call;
select * from prospect_matching;
select * from prospect;
select * from spouse;
select * from caller;
select * from interview;
select * from manager;
select * from applicant;
select * from supervisor;
select * from management;
select * from person;
select * from score;
select * from zip;
select * from timeslot;
select * from timeperiod;
select * from status;
select * from day;
select * from calling_pool;
select * from donor_type;
select * from call_result;
select * from department;
select * from training_type;
select * from action_taken;
select * from reason_for_action;
select * from major;
select * from matching_company;

/* Sample SQL Queries */


/* 1. Check employee attendance on 10/31 */
alter session set nls_date_format='mm-dd-yy';
Select d.d_date AS Day, t.time_period AS Timeslot, p.fn AS First_Name, p.ln AS Last_Name, e.status_code
FROM emp_schedule e, person p, day d, timeperiod t
Where e.Time_period_id = t.Time_period_id AND p.person_id = e.person_id AND e.day_id = d.day_id AND e.day_id = 161031
order by t.time_period;


/* 2. Manager/Supervisor's view for all employee's working hour for the week 2016.10.31-11.5 */
Create view Attendance1031 AS
  Select p.fn AS First_Name, p.ln AS Last_Name, count(*)*2 AS Working_Hour
  From person p, emp_schedule e, day d
  Where p.person_id = e.person_id AND d.day_id = e.day_id AND d.D_DATE >= '10-30-2016' AND d.D_DATE <= '11-05-2016' 
  Group by p.fn, p.ln;

SELECT * FROM Attendance1031;

/* 3. View for employee 9856974323 check his/her one month status */
Create view Attendance9856974323 AS
  SELECT s.status_code,  s.description, count(*) AS Counts
  FROM emp_schedule e, status s
  WHERE e.status_code = s.status_code AND e.person_id = 9856974323
  GROUP BY s.status_code, s.description;
  
SELECT * FROM Attendance9856974323;

/* 4. Check prospect information and their pledge amount in Calling pool of Accounting Department */
SELECT p.fn AS First_Name, p.ln AS Last_Name, count(*) AS Pledge_Count, sum(g.amount) as Pledge_Amt
FROM person p, prospect r, calling_pool c, department d, Gift g, Call c
WHERE c.department = d.department AND d.description = 'Accounting' AND c.CP_code = r.CP_code AND p.person_id = r.person_id AND c.Call_id = g.Call_id AND c.prospect_id = p. person_id
GROUP BY p.person_id, p.fn, p.ln;

/* 5. Find all prospects in our matching company "KPMG" and count how many calls they have received from us*/
SELECT p.fn AS First_Name, p.ln AS Last_Name, count(c.Call_id) AS Calls_Received, m.description AS company
FROM prospect r, person p, call c, prospect_matching pm, matching_company m
WHERE r.person_id = p.person_id AND c.prospect_id = r.person_id AND pm.prospect_id = r.person_id AND m.company_id = pm.company_id AND m.description = 'KPMG'
GROUP BY p.fn, p.ln, m.description;

/* 6. Check all caller's calls made and gift earned. */
SELECT p.ln, p.ln, count(c.call_id) AS calls_made, sum(g.amount) AS gift_earned
FROM caller ca, person p, call c, gift g
WHERE ca.person_id = p.person_id AND ca.person_id = c.caller_id AND c.call_id = g.call_id
GROUP BY p.person_id, p.ln, p.ln;

/* 7. count how many prospects in one calling pool. */
SELECT c.CP_code, count(*)
FROM calling_pool c, prospect p
WHERE c.CP_code = p.CP_code
GROUP BY c.CP_code;

/* 8. Manager check interview and applicant names on 8-21-2016 */
SELECT p.fn, p.ln
FROM interview i, person p
WHERE i.applicant_id = p.person_id AND i.interview_date = '08-21-2016';

/*9. Find out pledge rate of each calling pool with more than 1 call*/
SELECT cp.CP_code, Count(g.gift_id)/Count(c.call_id) AS PledgeRate
FROM calling_pool cp, gift g, call c, prospect p
WHERE g.call_id = c.call_id AND c.prospect_id = p.person_id AND p.CP_code = cp.CP_code
GROUP BY cp.CP_code
HAVING COUNT(c.call_id)>1;

/* 10. Find out gifts amount more than average and their donor's information */
SELECT g.amount AS GiftAmount, p.ln, p.fn, pr.CP_code, pr.school, pr.degree, pr.campus
FROM gift g, prospect pr, person p, call c
WHERE g.call_id = c.call_id AND c.prospect_id = p.person_id AND pr.person_id = p.person_id AND g.amount >
  (SELECT AVG(amount)
  FROM gift);


COMMIT;

spool off;