/***********************************************************************************/
/* Program Name: Chris.Berardi_Hw10_prog */
/* Date Created: 7/24/15 */
/* Author: Chris Berardi */
/* Purpose: Solution to Homework assignment 10 of Stat 604, Summer 2015 */
/* */
/* */
/* Date Last Run: 7/25/15 */
/* Date Modified: 7/25/15 */
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
Stuff\homework\completed\Chris.Berardi_HW10_output.pdf' ;
/*---------------------------------------------------------------------------------
*/
/* Part 2*/
/* Create three data sets in the same merge step*/
/*---------------------------------------------------------------------------------
*/
/* sort the data by MapCity then School to allow for eventual merging, create new
data sets to prevent overwriting */
proc sort data = homedata.Ok_high
out = Ok_high;
by MapCity School;
run;
proc sort data = homedata.Ok_mid
out = Ok_mid;
by MapCity School;
run;
/* 2b-c keep only those variables specified */
data combined(drop=i mid_grade: high_grade: ptr_:) high_only(keep=school--County)
mid_only(keep= school--County);
/* 2a merge the sorted data sets mid then high to allow high school data to
overwrite the middle school data */
/* rename all grade levels with prefixes to prevent overwriting and to allow easier
use later */
/* drop the teachers variable */
/* drop ungraded through Hstotal using their posistions in the data set */
/* create to IN variables to be used later to determine which middle and high
schools have no pair */
/* rename the PTRatio variables for each school type to allow them to be used to
calculate the combined PTRatio */
merge Ok_mid (in = mid rename=(Grade7-Grade12=mid_Grade7-mid_Grade12
PTRatio=ptr_mid) drop=Teachers ungraded--HStotal)
Ok_high (in = high rename=(Grade7-Grade12=high_Grade7-high_Grade12
PTRatio=ptr_high) drop=Teachers ungraded--HStotal);
by MapCity School;
/* 2ai Create three arrys, the first two using the renamed grades with prefixes,
the third creates new grade variables with a list*/
array mid_grades{*} mid_grade:;
array high_grades{*} high_grade:;
array grades{*} grade7-grade12;
teacher = 0;
/* 2aii using a loop sum together the number of students in each grade, use a sum
function to tolerate missing values */
do i=1 to 6;
grades{i}=sum(mid_grades{i}, high_grades{i});
/* 2aiii impute the number of teachers from the teacher ratio of the type of school
and the number of students at that school*/
if mid_grades{i} >0 then teacher = sum(teacher,
mid_grades{i}/ptr_mid);
if high_grades{i} >0 then teacher = sum(teacher,
high_grades{i}/ptr_high);
end;
/* 2aiv after the loop use the ceiling function to round the number of teachers up
the the next integer*/
teacher=ceil(teacher);
/* 2av sum the grades array to obtain the total enrollment */
total_enrollment = sum(of grades{*});
/* 2avi if the teacher variable is > 0, which also implies existence, compute a new
PTRatio based on the imputed value*/
if teacher > 0 then PTRatio = total_enrollment/teacher;
/* format that ration to two decimal places*/
format PTRatio 6.2;
/* In order from largest to smallest, output to the correct output data set based
on the IN values from the merge*/
if high eq 1 and mid eq 1 then output combined;
else if high eq 0 then output high_only;
else if mid eq 0 then output mid_only;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 3*/
/* Set orientation to landscape, reset the time to print the current time, supress
priting of page numbers*/
/* open the pfd ods output */
/*---------------------------------------------------------------------------------
*/
options DTreset NoNumber orientation = landscape;
ods pdf file=pdfout;
/*---------------------------------------------------------------------------------
*/
/* Part 4*/
/* sort the matched school data set place by descending PTRatio and
total_enrollment*/
/*---------------------------------------------------------------------------------
*/
proc sort data=combined;
by descending PTRatio descending total_enrollment;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 5*/
/* Using the variables, titles and footnotes specified in the output file, print
the */
/* first 20 obervations from the matched dataset. Label the variables in the proc
step */
/* to make the label temporary. Use titles 1 and 3 to allow for a space between the
two*/
/*---------------------------------------------------------------------------------
*/
proc print data=combined (obs=20) label;
var School MapCity County Teacher total_enrollment PTRatio;
label MapCity='City'
Teacher='Teachers'
total_enrollment='Students'
PTRatio = 'Pupil/Teacher Ratio';
title1 'Oklahoma Public Schools';
title3 'Twenty Schools with Highest Pupil/Teacher Ratios';
footnote 'Source: National Center for Education Statistics (nces.ed.gov)';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 6*/
/* remove the foot note and supress the priting of time and dates*/
/*---------------------------------------------------------------------------------
*/
options NoDate;
footnote;
/*---------------------------------------------------------------------------------
*/
/* Part 7*/
/* print the frequency report from the matched data set, ordering by frequency
instead */
/* alphbetical order. Remove cumulative results from the output and */
/* place the title on the second remove to remove the space.*/
/*---------------------------------------------------------------------------------
*/
proc freq data=combined order=freq;
Tables county /nocum;
title2 'Number of Schools by County';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 8*/
/* Print a means report with the statistics specified by the sample output*/
/* reset the second title and add a third to allow for a space */
/* specify a maximum decimal length of 2 */
/*---------------------------------------------------------------------------------
*/
proc means data =combined mean median Q1 Q3 maxdec=2;
var PTRatio;
class county;
title2;
title3 'Analysis of Pupil/Teacher Ratio by County';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 9*/
/* Reproduce the above results with a tabulate report*/
/* cross tabulate PTratio with the desired statistics */
/*---------------------------------------------------------------------------------
*/
proc tabulate data=combined;
class county;
var PTRatio;
Table county, PTratio*(n mean median Q1 Q3);
run;
/*---------------------------------------------------------------------------------
*/
/* Part 10*/
/* print the descriptor portion of the data sets in the work library in a single
proc step*/
/*---------------------------------------------------------------------------------
*/
proc contents data=work._all_;
run;
ods pdf close;
