![](SGTE.gif)

# SGTE ThermDoc database and exploration tools

SGTE ThermDoc Datatabase and exploration tools for finding references about thermodynamical properties of multinaries and inorganic compounds. Research functions are similar to Papyrus except for the Graphic User Interface.

## A bit of history

SGTE is an international consortium created more than 40 years ago. SGTE focuses on providing physically validated thermochemical databases to be used by computational thermochemistry software tools. General databases on unaries, compounds, solutions are created and maintained as well as new databases dedicated to specific target applications meeting global challenges such as e-mobility, energy generation and conversion as well as life sciences are developed. 

The ThermDoc database itself is a collection of more than 100,000 literature references from 1848 to 2024 formatted in order to easily find data on multinaries and updated every year by member of the consortium. The aim of this public repository is to share the database and easy-to-use and open sourced exploration tools with the maximum number of researcher around the world.

## Installation

- Install the multi-platforms [GNU Octave programming language for scientific computing](https://octave.org/) or use Matlab;
- Clone the repository to a local folder and go to the ./Code folder;
- Use the intuitive syntax to extract references from the ThermDoc database;
- Results are stored in the ./Search_results folder, a txt file for each inquiry.

Each inquiry takes about 10 seconds on Matlab and about 2-3 times more on GNU Octave but results are the same. Commands can be run from Octave-CLI in command line or Octage-GUI.

## Intuitive use
Here are some example of commands that can be used:
```matlab
Search_for_elements('Mo','Mg','Al')
```
->extract Mo-Mg-Al ternaries related papers. Any element can be added to the list. Inquiry is case sensitive, MO, MG and AL are not allowed as command argument. The more the elements, the slower the search as any possible combination must be assessed.
```matlab
Search_for_authors('CHATILLON','NUTA')
```
 ->extract papers containing Chatillon OR Nuta as authors, authors must be entered in UPPERCASE as arguments.
```matlab
Search_for_years('1914','1915','1916','1917','1918') 
```
->extract papers all papers referenced between 1914 and 1918.
```matlab
Search_for_keywords('PLUTONIUM','OSMIUM') 
```
->extract papers containing Plutonium OR Osmium in the title, keywords must be entered in UPPERCASE as arguments.

Commands can of course be scripted and ran as a batch, see ./Codes/Script.m for example of script containing several commands.

## Database maintenance

This part is not required to use the database as I will update it regularly but if you want to update it whatever the reason, go to:
```
./Codes/Service_folder/Source_database/
```
And copy/paste the new database you want to process, then run (after updating the database name in the database_in=XXX field):
```
./Codes/Service_folder/Service_script.m
```
The script will:
- detect any lacking field and report it in the ./Codes/Service_folder/Error_outputs/ folder. The original database contains lots of missinge titles, this is normal. Any other lackig field should be fixed;
- detect any issue in the "cle" field containing elements. Indeed, the elements list does not always end by / which slows down the search;
- convert to UPPERCASE the reference and authors fiels as the database contains both lowercase and uppercase entries, and the GNU Octave code is case sensitive;
- sort and copy by descending year all entries of the original database to the working database;

The original database is never modified during the maintenance, all operations are made on the working database only. The service script take about 20 minutes on Matlab to one hour with GNU Octave so it is not advised to use it as the working databse provided in the repo is always up to date regarding the original database. It may be used in case of frequent crash of the working database only, to rebuild it.

## License

- the GNU Octave codes provided are under the GPL-3.0 license
- the ThermDoc database is property of [SGTE - Scientific Group Thermodata Europe](https://www.sgte.net/en/)

## To cite the database in your work
