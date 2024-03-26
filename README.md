![](SGTE.gif)

# SGTE ThermDoc database and extraction tools
SGTE ThermDoc Datatabase and extraction tools for finding references about thermodynamical properties of multinaries

##Installation
- Install the multi-platforms [GNU Octave programming language for scientific computing](https://octave.org/);
- Clone the repository to a local folder and go to the working folder;
- Use the intuitive syntax to extract references from the ThermDoc database:

```
Search_for_elements('Mo','Mg','Al','Sorted_database.txt') ->extract Mo AND Mg AND Al ternaries related papers
Search_for_authors('Chatillon','Nuta','Sorted_database.txt') ->extract papers containing Chatillon OR Nuta as author
Search_for_years('1914','1918','Sorted_database.txt') ->extract papers containing 1914 OR 1918 as year
Search_for_keywords('Plutonium','Osmium','Sorted_database.txt') ->extract papers containing Osmium OR Plutonium in the title
```
