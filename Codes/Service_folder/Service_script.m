clc
disp('***************************************************************')
disp('******Start of database formatting, this may take a while******')
disp('***************************************************************')
disp(' ')
database_in='./Source_database/ThermDoc23a.bib';
database_out='./Source_database/Sorted_database.bib';
Extract_missing_titles(database_in)
Extract_missing_authors(database_in)
Extract_missing_references(database_in)
Extract_missing_keys(database_in)
Extract_missing_dates(database_in)
Sort_by_dates_and_fix_syntax(database_in, database_out)
disp(['CRC32 of the working database: ', num2str(crc32(fileread(database_out)))])%for me to check Octave/Matlab compatibility
%Build_structure(database_out) %in fact, there is no gain in time for search using such a structure...
disp(' ')
disp('****************************************************************')
disp('*******End of database formatting, you can explore it now*******')
disp('****************************************************************')

