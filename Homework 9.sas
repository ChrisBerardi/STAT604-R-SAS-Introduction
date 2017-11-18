/***********************************************************************************/
/* Program Name: Chris.Berardi_Hw09_prog */
/* Date Created: 7/18/15 */
/* Author: Chris Berardi */
/* Purpose: Solution to Homework assignment 9 of Stat 604, Summer 2015 */
/* */
/* */
/* Date Last Run: 7/19/15 */
/* Date Modified: 7/19/15 */
/***********************************************************************************/
/*---------------------------------------------------------------------------------
*/
/* Part 1*/
/* Create libname and filename for output file, open pdf for ouput */
/*---------------------------------------------------------------------------------
*/
libname HomeData 'C:\Users\Saistout\Desktop\604 Stuff\homework\data\'
access=readonly;
libname HomeOut 'C:\Users\Saistout\Desktop\604 Stuff\homework\data output';
filename pdfout 'C:\Users\Saistout\Desktop\604
Stuff\homework\completed\Chris.Berardi_HW09_output.pdf' ;
ods pdf file=pdfout;
/*---------------------------------------------------------------------------------
*/
/* Part 2*/
/* Create a narrow data set containing only the employee id, the charity name and
the index value */
/*---------------------------------------------------------------------------------
*/
data homeout.clfco_org(drop = charity:);
set homedata.clfco_2015(keep = employee_id charity:);
/* set length of organization to 100 to allow for longer future charity names */
length organization $100;
/* define i before loop to preventing it from being dropped */
i = 1;
array charities{*} $ charity:;
/* use dim() function to allow for growth in number of charities */
do i =1 to dim(charities);
/* Exclude any missing missing value for charity names */
if charities{i} ne '' then do;
organization = charities{i};
output;
end;
end;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 3*/
/* Sort new data set in place by organization to allw for merging with charities
data set */
/*---------------------------------------------------------------------------------
*/
proc sort data = homeout.clfco_org;
by organization;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 4*/
/* Created a sorted copy of the charities data set in the work directory */
/*---------------------------------------------------------------------------------
*/
proc sort data =homedata.charities
out = charities_sorted;
by organization;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 5*/
/* Merge the sorted organization and charities data, remove charities with no
contributions*/
/*---------------------------------------------------------------------------------
*/
data org_cat;
merge homeout.clfco_org charities_sorted;
by organization;
/* drop unwanted org_id variable */
drop org_id;
/* only ouput if the index value exists, i.e., the charity has been donated to */
if i ne .;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 6*/
/* Tranpose the merged data set into a wide data set using the transpose
procedure*/
/*---------------------------------------------------------------------------------
*/
/* sort the data set by employee_id as it will be a by group in the transpose
proc*/
proc sort data=org_cat;
by employee_id;
run;
/* transpose the data by employee_id to get desired results */
proc transpose data=org_cat
/* output to same data faile, drop unwatned variables */
out = org_cat(drop = _name_ _label_)
/* use a prefix to generate the same names as on the sample output */
prefix = Donee_Type;
by employee_id;
/* category is what needs to be tranposed */
var category;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 7*/
/* Merge the original clfco_2015 data with the data organized by category*/
/* add variables for total religious, relief contribution, total contributions, */
/* as well as contributions as a percent of salary /*
/*---------------------------------------------------------------------------------
*/
data charity_type(drop =i);
merge homedata.clfco_2015 org_cat;
/* create two arrays, one for the type of organization and for the amount donated
*/
array type{*} $ Donee_Type:;
array amount{*} amount:;
/* initialize new variables to zero */
char_relig =0;
char_relif =0;
char_total = 0;
char_percent = 0;
/* use arrays to sum the contributions to religous and relief organizations */
do i=1 to dim(type);
if type{i} eq 'Religious' then char_relig+amount{i};
if type{i} eq 'Relief' then char_relif+amount{i};
end;
/* sum the total donated using the amount{} array */
char_total = sum(of amount{*});
/* calculate the percent donated */
char_percent = char_total/salary;
/* specificy the labels as defined in the sample output */
label char_relig = 'Religious Amount'
char_relif = 'Relief Amount'
char_total = 'Total Contributions'
char_percent = '% of Salary Given';
/* format the percentage output according to the sample */
format char_percent percent7.1;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 8*/
/* Print out the descriptor and datd poritios of the final data set*/
/*---------------------------------------------------------------------------------
*/
proc contents data=charity_type;
run;
/* supress the observations numbers, use labels and output only the variables in
the correct order from the sample output */
proc print data=charity_type noobs label;
var employee_id name department salary char_relig char_relif char_total
char_percent;
run;
ods pdf close;
