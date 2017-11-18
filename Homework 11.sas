/***********************************************************************************/
/* Program Name: Chris.Berardi_Hw11_prog */
/* Date Created: 7/28/15 */
/* Author: Chris Berardi */
/* Purpose: Solution to Homework assignment 11 of Stat 604, Summer 2015 */
/* */
/* */
/* Date Last Run: 7/30/15 */
/* Date Modified: 7/30/15 */
/***********************************************************************************/
/*---------------------------------------------------------------------------------
*/
/* Part 1*/
/* Create libname and filename for output file as well as for raw data files */
/*---------------------------------------------------------------------------------
*/
libname HomeData 'C:\Users\Saistout\Desktop\604 Stuff\homework\data\'
access=readonly;
libname HomeOut 'C:\Users\Saistout\Desktop\604 Stuff\homework\data output';
filename pdfout 'C:\Users\Saistout\Desktop\604
Stuff\homework\completed\Chris.Berardi_HW11_output.pdf' ;
filename election 'C:\Users\Saistout\Desktop\604
Stuff\homework\data\election_hist.csv';
filename region6 'C:\Users\Saistout\Desktop\604 Stuff\homework\data\region6.dat';
/*---------------------------------------------------------------------------------
*/
/* Part 2*/
/* create user defined formats to show various results as described by the
assignment */
/* be certain to specific N/A as the format for all other values*/
/*---------------------------------------------------------------------------------
*/
proc format;
value $campfmt 'I'= 'Incumbent'
'C'= 'Challenger'
'O'= 'Open Seat';
value partyfmt 1='Democratic'
2='Republican'
3='Other Party';
value $resultfmt 'W' = 'Won'
'L' = 'Lost'
'R' = 'Runoff'
other = 'N/A';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 3*/
/* Read in the comma delimited election_hist raw data file*/
/*---------------------------------------------------------------------------------
*/
/*3e drop the months_since variable from the incomplete data set */
data elections incomplete(drop= months_since);
/*3a specify the length of all character variables using the codebook */
/* Define the variables in order of how they appear on the output */
length Cand_ID $9
Cand_Name $37
Type $1
Party_Desig $3
State District $2
Special_Stat Primary_Stat Runoff_Stat General_Stat $1;
/* Use the MISSOVER option to read missing values as missing, set the delimeter to
a comma */
/* begin reading at the second observation, treat repeated delimeters
individually*/
infile election MISSOVER dlm=',' firstobs=2 DSD;
/*3b Read in the variables in the order they appear in the file using the same
names as those */
/* in the output. Specifcy the end_date informat with the length required if we
included delimeters*/
input Year Cand_ID Cand_Name Type Party Party_Desig Receipts Transfers_From
Disbursements Transfers_To Start_Cash End_Cash Cand_Contrib
Cand_Loans
Other_Loans Cand_Repay Other_Repay Debts Ind_Contrib State District
Special_Stat
Primary_Stat Runoff_Stat General_Stat General_Pct Pol_Contrib
Part_Contrib
End_date :mmddyy11. Ind_Refunds Ctte_Refunds;
/*3c format the appropriate variables with user defined formats, format end_date so
that it abbreviates the month name*/
format Type campfmt.
Party partyfmt.
Special_Stat Primary_Stat Runoff_Stat General_Stat resultfmt.
End_date WORDDATE12.;
/*3e If the row contains an error, write the observation to the temporary
incomplete data set*/
if _error_ = 1 then output incomplete;
/*3d Otherwise use the intck function, with a hardcoded stopping date to calculate
the months since the end_date variable*/
/*4f Then output the row to the temporary elections data set*/
else do;
months_since=intck('Month',End_date, '01Aug2015'd);
output elections;
end;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 4*/
/* Read in the column specified region6.dat raw data file*/
/*---------------------------------------------------------------------------------
*/
/* drop the adresses variable that was used to make reading the file easier*/
data region6(drop = Adresses);
/* use the TRUNCOVER option to make SAS more tolerant of variables that do not take
up the */
/* the entire length specified*/
infile region6 TRUNCOVER;
/* Use a combination of specified lengths, all as small as possible, starting
positions*/
/* and commands to read the end line to define how the raw data should be read in
*/
/* Dist_Id is character valued to preserve leading zeros*/
input School $39. @43 Street $30. / @16 Dist_Type $15. @43 Adresses $28./ @16
Dist_ID $7.
@50 Phone $14. / County $19. @48 Fax $14. / @43 Email $30. / @43
WebSite $30.;
/* Define three new variables of the smallest possible length to split up the
addesses variable */
length city $15
state $2
zip $10;
/* Use the scan function to find the various parts of an address */
city = scan(adresses,1, ',');
state = scan(adresses,-2, ' ');
zip = scan(adresses,-1, ' ');
run;
/*---------------------------------------------------------------------------------
*/
/* Part 5*/
/* Set orientation to landscape, supress time/date printing, set the starting
output page to 2*/
/* and open the pdf output*/
/*---------------------------------------------------------------------------------
*/
options orientation = landscape NODATE PAGENO = 2;
ods pdf file=pdfout;
/*---------------------------------------------------------------------------------
*/
/* Part 6*/
/* Print 15 observations from the elections data set from the year 2004*/
/* Use Split option to define break points for the months_since label */
/* Set the titles to those desired */
/*---------------------------------------------------------------------------------
*/
proc print data=elections (obs=15) split='*';
/*Use where to select only dates from 2004 */
where year = 2004;
label months_since = "Months Since*End of*Campaign";
Title1 'Federal Election Campaign Data';
Title3 'Sample from the Year 2004';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 7*/
/* Use univaraite procdeure to display extreme observations*/
/* Remove title3 and set title2*/
/*---------------------------------------------------------------------------------
*/
proc univariate data=elections;
var cand_loans other_loans;
title2 'Analysis of Candidate and Other Loans';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 8*/
/* Use a summary procedure to generation a report on average candidate
contributions and loans classified by party*/
/* output to a temporary data file renaming the desired output to the names seen on
the sample output*/
/*---------------------------------------------------------------------------------
*/
proc summary data=elections;
var cand_contrib cand_loans;
class Party;
output out = elections_summary
mean = avg_contrib avg_loans;
run;
/*---------------------------------------------------------------------------------
*/
/* Part 9*/
/* Print out the data portion of the summariest data, format the varibales to
appear as currency */
/* with no decimals, remove the title2 and add a title3 */
/*---------------------------------------------------------------------------------
*/
proc print data=elections_summary;
format avg_contrib dollar7.
avg_loans dollar7.;
title2 ;
title3 'Average Candidate Contributions and Loans by Political Party';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 10*/
/* Use a FREQ procedure to print out the frequnecy for counties in the reiong6 data
set use nLevels to print*/
/* out the total number of counties in the data set. Set titles */
/*---------------------------------------------------------------------------------
*/
proc freq data=region6 nlevels;
Tables county;
title1 'Texas Education Agency Region VI';
title2 'Number of Counties and Schools in Each County';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 11*/
/* Turn on time/date, print out region6 data without observation numbers and*/
/* Write the specified tile*/
/*---------------------------------------------------------------------------------
*/
option Date;
proc print data=region6 Noobs;
title2 'Listing of Schools and Contact Information';
run;
/*---------------------------------------------------------------------------------
*/
/* Part 12*/
/* Clear all titles and footnotes for housekeeping, lose the output pdf.*/
/*---------------------------------------------------------------------------------
*/
title;
footnote;
ods pdf close;
