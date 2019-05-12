Within sql join a a text or excel file to a SAS or foreign table without proc import

Given a list of student names in excel or a text file, select
the students age, gender, height and weight from the master table.
Do all processing inside a single SQL query.


   Three solutions

        1. Within 'proc sql' join a SAS table or foreign table
           to an excel sheet or named range (without proc import)

        2. Within 'proc sql' join a a text file to SAS or foreign table (without proc import)

        3. Within 'proc sql' join a text rable ro a SAS table of foreign table using datastep options
           (without proc import)


github
https://tinyurl.com/y3ves6ym
https://github.com/rogerjdeangelis/utl-within-sql-join-a-a-text-or-excel-file-to-a-sas-or-foreign-table-without-proc-import

Inspired by
https://tinyurl.com/y3neyaj3
https://stackoverflow.com/questions/56009799/sas-using-proc-imported-csv-in-proc-sql-error

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

* just to have a clear environment;
%utlfkil(d:/txt/subSetTxt.txt);
%utlfkil(d:/xls/subSetXls.xlsx);

* excel sheet or named range;
libname xel "d:/xls/subSetXls.xlsx";
data subsetXls;
  set sashelp.class(where=(name =: "J"));
run;quit;

* text file;
data _null_;
  set sashelp.class(where=(name=:"J"));
  file ""d:/xls/subSetTxt.txt";
  put name;
run;quit;


 d:/xls/class.xlsx

      +------------+
      |     A      |
      +-------------
   1  | NAME       |
      +------------+
   2  | James      |
      +------------+
   3  | Jane       |
      +------------+
   4  | Janet      |
      +------------+
   5  | Jeffrey    |
      +------------+
   6  | Joah       |
      +------------+
   7  | Joyce      |
      +------------+
   8  | Judy       |
      +------------+


 d:/txt/subSetTxt.txt

   James
   Jane
   Janet
   Jeffrey
   John
   Joyce
   Judy

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

WORK.WANT total obs=6

Obs    NAME       SEX    AGE    HEIGHT    WEIGHT

 1     Jane        F      12     59.8       84.5
 2     Janet       F      15     62.5      112.5
 3     Jeffrey     M      13     62.5       84.0
 4     John        M      12     59.0       99.5
 5     Joyce       F      11     51.3       50.5
 6     Judy        F      14     64.3       90.0

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;


%utlfkil(d:/txt/subSetTxt.txt);
%utlfkil(d:/xls/subSetXls.xlsx);


* just to have a clear environment;
%utlfkil(d:/txt/subSetTxt.txt);
%utlfkil(d:/xls/subSetXls.xlsx);

* excel sheet or named range;
libname xel "d:/xls/subSetXls.xlsx";
data subsetXls;
  set sashelp.class(where=(name =: "J"));
run;quit;

* text file;
data _null_;
  set sashelp.class(where=(name=:"J"));
  file ""d:/xls/subSetTxt.txt";
  put name;
run;quit;


************************************************************
1. Within 'proc sql' join a SAS table or foreign table     *
   to an excel sheet or named range (without proc import)  *
************************************************************

libname xel "d:/xls/class.xlsx";
proc sql;

  create
     table wantXls as

  select
     *
  from
     sashelp.class
  where
     name in
       (
        select
           name
        from
           xel.subset
       )
;quit;


********************************************************************
2. Join a a text file to SAS or foreign table (without proc import)*
********************************************************************

proc sql;

  create
     table wantTxt as

  select
     *
  from
     sashelp.class

  where  /* inside the sql where clase */

     0=%sysfunc(dosubl('
       data subdo;
          informat name $7.;
          infile "d:/txt/names.txt";
          input name;
       run;quit;
      ')) and

     name in
       (
        select
           name
        from
           subdo
       )
;quit;


******************************************************************************
3. Join a text rable ro a SAS table of foreign table using datastep options  *
   (without proc import)                                                     *
******************************************************************************

proc sql;

  create
     table want as

  select
     *
  from
     sashelp.class   /* inside the the input datastep where clase */
         (where=(0=%sysfunc(dosubl('
          data subdo;
             informat name $7.;
             infile "d:/txt/names.txt";
             input name;
          run;quit;
          '))
      ))
  where
     name in
       (
        select
           name
        from
           subdo
       )
;quit;

