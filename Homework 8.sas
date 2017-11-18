/***********************************************************************************/
/* Program Name: Chris.Berardi_Hw08_prog */
/* Date Created: 7/5/15 */
/* Author: Chris Berardi */
/* Purpose: Solution to Homework assignment 8 of Stat 604, Summer 2015 */
/* */
/* */
/* Date Last Run: 7/6/15 */
/* Date Modified: 7/5/15 */
/***********************************************************************************/
/*---------------------------------------------------------------------------------
*/
/* Part 1*/
/* Create libname and filename for output file */
/*---------------------------------------------------------------------------------
*/
libname HomeData 'C:\Users\Saistout\Desktop\604 Stuff\homework\data\'
access=readonly;
libname HomeOut 'C:\Users\Saistout\Desktop\604 Stuff\homework\data output';
filename pdfout 'C:\Users\Saistout\Desktop\604
Stuff\homework\completed\Chris.Berardi_HW08_output.pdf' ;
/*---------------------------------------------------------------------------------
*/
/* Part 2*/
/* Create libname and filename for output file */
/*---------------------------------------------------------------------------------
*/
data HomeOut.Ok_clean(drop=XCounty XGrade8 XGrade9 XGrade10 XGrade11 XGrade12);
/* Rename the County variable to XCounty and all Grades for their eventual removal
*/
set HomeData.Ok_schools(rename=(County=XCounty Grade8=XGrade8 Grade9=XGrade9
Grade10=XGrade10 Grade11=XGrade11 Grade12=XGrade12));
/* Use the longest county name to assign the variable county */
County = ' ';
/* 2a. Use the SCAN function to take the first word of each observation in XCounty
*/
County = scan(XCounty, 1);
/* Define all grade variables with a missing value to simplying the select
statments */
Grade8= .;
Grade9= .;
Grade10= .;
Grade11= .;
Grade12= .;
/* 2b Using SELECT statement, one for each grade, convert all grade data to numeric
*/
select (XGrade8);
when ('n/a');
when ('*');
otherwise Grade8=input(XGrade8,3.);
end;
select (XGrade9);
when ('n/a');
when ('*');
otherwise Grade9=input(XGrade9,3.);
end;
select (XGrade10);
when ('n/a');
when ('*');
otherwise Grade10=input(XGrade10,3.);
end;
select (XGrade11);
when ('n/a');
when ('*');
otherwise Grade11=input(XGrade11,3.);
end;
select (XGrade12);
when ('n/a');
when ('*');
otherwise Grade12=input(XGrade12,3.);
end;
/* 2c Correct Various misspellings with a select group */
select(City);
when ('CHUOTEAU') City='CHOUTEAU';
when ('OKC') City='OKLAHOMA CITY';
when ('JENKS') City='TULSA';
when ('MUSKOGE') City='MUSKOGEE';
when ('RUSHSPRINGS') City='RUSH SPRINGS';
when ('SEMIONOLE') City= 'SEMINOLE';
when ('SO. COFFEYVILLE') City = 'SOUTH COFFEYVILLE';
when ('WOOWARD') City= 'WOODWARD';
otherwise;
end;
/* 2d Use an if statement to change the city listed for Alfala county */
if County eq 'ALFALFA' then city = 'CHEROKEE';
run;
/* 3a use a SORT to sort the Ok_clean data according to City */
proc sort data =HomeOut.Ok_Clean;
by City;
run;
/* 3b drop the school from being read in for efficiency, drop all grades as list
from the output */
data projection(drop= Grade:);
set HomeOut.Ok_Clean(drop= School);
/* 3c create new variables for the grade summaries, each starting with the same
letter for uniquness*/
retain G8 0;
retain G9 0;
retain G10 0;
retain G11 0;
retain G12 0;
/* Each of the cummulative variables need not be retained */
C_enrol = 0;
P_enrol = 0;
Change = 0;
/* create permanent labels for them */
label G8 = 'Eigth Graders'
G9 = 'Freshmen'
G10 = 'Sophomores'
G11 = 'Juniors'
G12 = 'Seniors'
C_Enrol = 'Current Enrollment'
P_Enrol = 'Projected Enrollment';
/* Format the change variable as specified */
format Change percent7.1;
/* By city, create the the sum of all students in the city */
By City;
/* Set all variables to zero on the first observation per city */
if first.City then do
G8 = 0;
G9 = 0;
G10 = 0;
G11 = 0;
G12 = 0;
end;
/* Sum all grades for each observation per city */
G8+Grade8;
G9+Grade9;
G10+Grade10;
G11+Grade11;
G12+Grade12;
/*Return to start of data step if not the last observation for a city*/
if last.City;
/*3 d,e After last observation sum to obtain current and projected enrollment using
numeric ranges */
C_Enrol= sum(of G9-G12);
P_Enrol= sum(of G8-G11);
/*3f Make sure current enrollment exists, then calculate the change in enrollment
*/
if C_Enrol ne 0 then Change = (P_Enrol-C_Enrol)/C_Enrol;
/*3g Output only if all grades exist */
if G8 ne 0 and G9 ne 0 and G10 ne 0 and G11 ne 0 and G12 ne 0 then
output;
run;
/*4 open pdf output and slect no bookmarks */
ods pdf file = pdfout bookmarkgen=no;
/*5 Print out descriptor and data portion of the cleaned data set */
proc contents data=homeout.ok_clean;
run;
proc print data=homeout.ok_clean label;
run;
/*5 Print ou the descriptor and data portions of the school projection data set */
proc contents data=projection;
run;
proc print data=projection label;
run;
ods pdf close;
