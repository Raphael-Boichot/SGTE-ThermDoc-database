![](/Images/Logo%20SGTE.png)

# SGTE ThermDoc database and exploration tools

SGTE ThermDoc Datatabase and exploration tools in command line for finding references about thermodynamical properties of multinaries and inorganic compounds. Research functions are similar to Papyrus except for the Graphic User Interface.

## A brief history

SGTE is an international consortium created more than 40 years ago in Grenoble (France). SGTE focuses on providing physically validated thermochemical databases to be used by computational thermochemistry software tools. General databases on unaries, compounds, solutions are created and maintained as well as new databases dedicated to specific target applications meeting global challenges such as e-mobility, energy generation and conversion as well as life sciences are developed. 

The **ThermDoc** database itself is a collection of more than 100,000 literature references from 1848 to now, formatted in order to easily find data on multinaries and updated every year by leading members of the consortium. The aim of this public repository is to share the database, easy-to-use and open sourced exploration tools, with the maximum number of researchers around the world.

## Installation and use

**It is recommended to use Octace GUI (Graphic User Interface) which requires only editing pre-existing scripts and clicking on run. Octave CLI (Command Line Interface) provides a Linux feeling on Windows and works the same but requires writing the complete commands.** All codes are directly compatible with Matlab in case you own a license.

- Install the multi-platforms [GNU Octave programming language for scientific computing](https://octave.org/) and associate with the *.m file extension;
- Download the repository an unzip it to a local folder and go to the **./Code** folder;

**Easy launch with the GNU Octave GUI:**
- Right click on **Script.m** -> Open with -> GNU Octave Launcher;

OR
- Launch GNU Octave GUI and navigate to the **./Code** folder from the "File browser" 
- Edit the **script.m** file;
- Run with "Save and run";
- Choose "Change directory";
- Go to the "command window" or to the dedicated result folder to see the results.

![](/Images/Scripting.png)

**Linux feeling launch with the GNU Octave CLI:**
- from the **GNU Octave CLI**, go to the **./Code** folder. GNU Octave Command Line Interface (CLI) accepts both the classical bash and DOS commands (pwd, cd, dir, ls, etc.) plus all the Matlab commands;
- Use the intuitive syntax (see next section) or edit **Script.m** in any text editor, then save and run it like this:
```matlab
Script 
```
![](/Images/Scripting_2.png)

- Search results are stored in the **./Search_results** folder, a txt file for each inquiry (results are just formatted in ASCII text file);
- You can kill a running process at any time with Ctrl+C.

Each inquiry takes about 10 seconds on GNU Octave. References will be sorted by descending year.

## Example of syntax
Here are some example of commands that can be used directly or scripted, supposing that you are in the **[./Code](/Codes)** directory:

**Search for elements and multinaries**
```matlab
Search_for_elements('Mo')           %search for citations about pure Molybdenum metal only
Search_for_elements('Al','Mo')      %search for citations about Al-Mo binary only
Search_for_elements('Al','Cu','Mo') %search for citations about Al-Cu-Mo ternary only
```
Any element can be added to the list. The more the elements, the slower the search as any possible combination (n! typically) must be assessed (elements are not always listed by atomic mass in the database). The current version of the code does not allow yet to refine an enquiry (like papers about Mg-Al binaries from a particular author), may be programmed on request. Arguments are **not case sensitive for elements** ('MO' and 'Mo' acts the same as argument to include molybdenum into the search).

**Search for authors**
```matlab
Search_for_authors('Chatillon','Nuta')  %search for Chatillon and Nuta as authors
```
The command extract references with Author#1 **and** Author#2 **and** Author#3, and so on. Arguments are **not case or accent sensitive** ('Brönsted', 'Bronsted' and 'BRONSTED' are equivalent arguments).

**Search for keywords in the reference title**
```matlab
Search_for_keywords('Plutonium','Osmium') %search for Plutonium and Osmium in the title
```
The command extract references with Keyword#1 **and** Keyword#2 **and** Keyword#3, and so on. Arguments are **not case or accent sensitive** ('Sélénium', 'Selenium' and 'SELENIUM' are equivalent arguments).

## Database maintenance for administrators

Regular users are not expected to perform this task as the provided files are up to date and easier to clone from the repository but if you want to update it whatever the reason, go to:
```
./Codes/Service_folder/Source_database/
```
And copy/paste the new database you want to process, update the name in [Service_script.m](/Codes/Service_folder/Service_script.m#L6), then run:
```matlab
Service_script
```
![](/Images/Scripting_3.png)

The script will:
- detect any lacking field / inconsistency and report it in the **[./Codes/Service_folder/Error_outputs/](/Codes/Service_folder/Error_outputs)** folder. The original database contains lots of missing titles, this is normal seing the sometimes improbable sources. Any other lacking field should be fixed soon;
- detect any issue in the "cle" field containing elements. Indeed, the elements list does not always end by / which slows down the search. It also adds a starting / to each "cle" to fasten search for multinaries;
- sort and copy by descending year all entries of the original database to the working database;
- remove the accents from European names/titles;
- Calculate the CRC32 checksum of the source and working database.

The original database is never modified during the maintenance, all operations are made on the working database only.

## Dev notes
- The codes attack the database in text format by brute force. It could appear slow but I've tried using more elaborated formats like structures and it does not speed up the process at all. It is slow because the database is huge.
- Due to the more or less automated method for extraction of references, they could contain characters from the extended Windows-1252 table which is not an ANSI standard. They are actively searched/cleared and replaced with corresponding ANSI standardized ISO-8859-1 characters.

## Licenses
- The GNU Octave codes are provided under the GPL-3.0 license. You are allowed to distribute/modify them as long as you cite the author (Raphaël BOICHOT).
- The ThermDoc database is shared free of charge and is property of the [SGTE - Scientific Group Thermodata Europe](https://www.sgte.net/en/)

## Authors who have contributed or are contributing today to the database
- **Himo Ansara**, French National Centre for Scientific Research and founder member of CALPHAD
- **Aljette Ansara**, LTPCM, École nationale supérieure d'électrochimie et d'électrométallurgie de Grenoble
- **Bertrand Cheynet**, French National Centre for Scientific Research
- **Philip Spencer**, Aachen University of Technology, founder member of CALPHAD
- **Christian Chatillon**, French National Centre for Scientific Research
- **Catherine Colinet**, French National Centre for Scientific Research
- **Alan Dinsdale**, Brunel University London · Brunel Centre for Advanced Solidification Technology
- **Annie Antoni**, Institut Polytechnique de Grenoble, Grenoble Alpes University 
- **Bengt Hallstedt**, Institute of Materials Applications in Mechanical Engineering, RWTH Aachen University
- Evelyne Fisher, Institut Polytechnique de Grenoble, Grenoble Alpes University 

## Aknowledgements
Special thanks to Alexander Pisch (president of SGTE) and Evelyne Fisher for their confidence in giving me this task.
