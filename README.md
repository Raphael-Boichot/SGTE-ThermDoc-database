![](SGTE.gif)

# SGTE ThermDoc database and exploration tools
SGTE ThermDoc Datatabase and exploration tools for finding references about thermodynamical properties of multinaries and inorganic compounds.

## Installation
- Install the multi-platforms [GNU Octave programming language for scientific computing](https://octave.org/) or use Matlab;
- Clone the repository to a local folder and go to the ./Code folder;
- Use the intuitive syntax to extract references from the ThermDoc database;
- Results are stored in the ./Search_results folder, a txt file for each inquiry.

Each inquiry takes about 5 seconds on Matlab and about 2-3 times more on GNU Octave but results are the same. Commands can be run from Octave-CLI in command line or Octage-GUI.

## Intuitive use
Here are some example of commands that can be used:
```
Search_for_elements('Mo','Mg','Al')
```
->extract Mo-Mg-Al ternaries related papers. Any element can be added to the list.
```
Search_for_authors('CHATILLON','NUTA')
```
 ->extract papers containing Chatillon OR Nuta as authors, authors must be entered in UPPERCASE
```
Search_for_years('1914','1915','1916','1917','1918') 
```
->extract papers all papers referenced between 1914 and 1918.
```
Search_for_keywords('PLUTONIUM','OSMIUM') 
```
->extract papers containing Plutonium OR Osmium in the title, keywords must be entered in UPPERCASE

Commands can of course be scripted and ran as a batch, see ./Codes/Script.m for example of scripts.

## Database maintenance

This part is not required to use the database as I will update it regularly but if you want to update it, go to:
```
./Codes/Service_folder/Source_database/
```
And copy/paste the new database, then run (after updating the database name in the database_in=XXX field):
```
./Codes/Service_folder/Service_script.m
```
The script will:
- detect any lacking field and report it in the ./Codes/Service_folder/Error_outputs/ folder;
- detect any syntax issue in the cle fiels contaning elements;
- convert to UPPERCASE the reference and authors fiels;
- sort and copy by descending year all entries of the original database to the working database;

The original database is never modified during the maintenance. The service script take about 20 minutes on Matlab to one hour with GNU Octave so it is not advised to use it as the code provided in the repo are all up to date.
