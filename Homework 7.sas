/
***********************************************************************************
/
/* Program Name: Chris.Berardi_Hw07_prog */
/* Date Created: 6/29/15 */
/* Author: Chris Berardi */
/* Purpose: Solution to Homework assignment 7 of Stat 604, Summer 2015 */
/* */
/* */
/* Date Last Run: 7/4/15 */
/* Date Modified: 7/3/15 */
/
***********************************************************************************
/
/*---------------------------------------------------------------------------------
*/
/* Part 2*/
/* Make data folder libref a readonly library */
/*---------------------------------------------------------------------------------
*/
libname HomeData 'C:\Users\Saistout\Desktop\604 Stuff\homework\data\'
access=readonly;
/*---------------------------------------------------------------------------------
*/
/* Part 3*/
/* Make data output libref */
/*---------------------------------------------------------------------------------
*/
libname HomeOut 'C:\Users\Saistout\Desktop\604 Stuff\homework\data output';
/*---------------------------------------------------------------------------------
*/
/* Part 4*/
/* Make fileref for the pdf output file, then open the pdf destination, */
/* add hidden boomarks.*/
/*---------------------------------------------------------------------------------
*/
filename pdfout 'C:\Users\Saistout\Desktop\604
Stuff\homework\completed\Chris.Berardi_HW07_output.pdf';
ods pdf file = pdfout bookmarklist=hide;
/*---------------------------------------------------------------------------------
*/
/* Part 5*/
/* Subset the Texas Schools data set. Remove all schools without students in high
school*/
/* Drop the Data, Type, Level, F16 and F17 variables */
/* Label fte_teacher, ptr, control, gr8, fr, so jr and sr */
/* create variable of the high school enrollment, us the sum function to ignore
missing values*/
/* create a loud date and format MM/DD/YYYY */
/*---------------------------------------------------------------------------------
*/
data HomeOut.Subset_schools;
set HomeData.Texas_schools;
where sr >= 1 or jr >= 1 or so >= 1 or fr >= 1;
drop State Type Level F16 F17;
label fte_teachers = 'Teacher fte'
ptr = 'Student/Teacher Ration'
control = 'School Type'
gr8 = 'Eight Grade'
fr = 'Freshmen'
so = 'Sophomores'
jr = 'Juniors'
sr = 'Seniors';
hs_enrol = sum(fr,so,jr,sr);
label hs_enrol = 'HS Enrollment';
ld_date = today();
label ld_date = 'Load Date';
format ld_date MMDDYY10.;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 6*/
/* Print descriptor porition of new data set*/
/*---------------------------------------------------------------------------------
*/
proc contents data=Homeout.Subset_schools;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 7*/
/* Print the first 9 observation with labels*/
/*---------------------------------------------------------------------------------
*/
proc print data=Homeout.Subset_schools(obs=9) label;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 8*/
/* Create a temporary academies data with only schools with ACADEMY in the name*/
/* Exclude the ACADEMY H S in Bell County */
/*---------------------------------------------------------------------------------
*/
data academies;
set HomeOut.Subset_schools;
where school contains 'ACADEMY' and school ne 'ACADEMY H S';
keep school hs_enrol control county;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 9*/
/* Print out the academy data set with labels and in the variable order specified*/
/*---------------------------------------------------------------------------------
*/
proc print data=academies label; var school hs_enrol control county;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 10*/
/* Create data set of those school where more than 25% of students are seniors, but
not all students are seniors*/
/*---------------------------------------------------------------------------------
*/
data sr_hs;
set HomeOut.subset_schools(keep=school county gr8 fr so jr sr hs_enrol);
if hs_enrol > sr and sr > .25*hs_enrol then
output;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 11*/
/* Print Data Portion of Previous Step with correct order and no obs number*/
/*---------------------------------------------------------------------------------
*/
proc print data=sr_hs label noobs; var school hs_enrol sr jr so fr gr8 county;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 12*/
/* To make as efficent as possible do the following: */
/* drop fte_teachers and ptr as they are not in output and not used in this step */
/* drop the correct variables from OneA and TAPS1 */
/* drop control as it will not be in output */
/* set the length of the Division variable to the longest possible */
/* As public schools make up the vast majority, do public first in condition and
through by size */
/* largest to smallest to run the loop as few times as possible */
/*---------------------------------------------------------------------------------
*/
data OneA(drop = Division) TAPS1(drop= County Division) Align15;
set HomeOut.subset_schools(drop=fte_teachers ptr);
where sr is not missing and jr is not missing and so is not missing and
fr is not missing and sr ne 0 and jr ne 0 and so ne 0 and fr ne 0;
drop control;
length Division $5;
if control = 'Public' then
if hs_enrol >= 2100 then
Division = '6A';
else if hs_enrol >= 1060 then
Division = '5A';
else if hs_enrol >= 465 then
Division = '4A';
else if hs_enrol >= 220 then
Division = '3A';
else if hs_enrol >= 105 then
Division = '2A';
else do
Division = '1A';
output OneA;
end;
else
if hs_enrol <=55 then do
Division = 'TAPS1';
output TAPS1;
end;
else if hs_enrol >= 111 then
Division = 'TAPS3';
else Division = 'TAPS2';
output Align15;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 13*/
/* Create temporary data set named GradeCount with the 4 variables kept */
/* For all grade levels that exist in a school, output the number in each grade and
the name of the grade */
/*---------------------------------------------------------------------------------
*/
data GradeCount(keep= school division grade students);
set Align15 (keep = school division gr8 fr so jr sr);
length grade $9;
if gr8 > 0 then do
grade = 'Eighth';
Students = gr8;
output;
end;
if fr > 0 then do
grade = 'Freshman';
Students = fr;
output;
end;
if so > 0 then do
grade = 'Sophomore';
Students = so;
output;
end;
if jr > 0 then do
grade = 'Junior';
Students = jr;
output;
end;
if sr > 0 then do
grade = 'Senior';
Students = sr;
output;
end;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 14*/
/* Print out the contents of the work library with the descriptor portion*/
/*---------------------------------------------------------------------------------
*/
proc contents data=work._ALL_ nods;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 15*/
/* Print out the the first 50 observations from Align15 starting with B F TERRY H
S*/
/*---------------------------------------------------------------------------------
*/
proc print data=Align15(obs=50) label noobs;
where school ge 'B F TERRY H S';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 16*/
/* Knowing that OneA has 482 observation, print out the last 30*/
/*---------------------------------------------------------------------------------
*/
proc print data=OneA(firstobs=454 obs=483) label Noobs;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 17*/
/* Print out the TAPS1 data set*/
/*---------------------------------------------------------------------------------
*/
proc print data=TAPS1 label;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 18*/
/* Print out the first 36 observation from GradeCount*/
/*---------------------------------------------------------------------------------
*/
proc print data=GradeCount(obs=38) label;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 19*/
/* Copying the proc step as outlined in the assignment*/
/*---------------------------------------------------------------------------------
*/
proc tabulate data=gradecount;
class division grade;
var students;
table grade='Grade', division*students=''*sum=''*f=comma7.;
run;
/*---------------------------------------------------------------------------------
*/
/* Close the pdf*/
/*---------------------------------------------------------------------------------
*/
ods pdf close;
