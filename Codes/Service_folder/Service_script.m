database_in='./Source_database/ThermDoc23a.bib';
database_out='./Source_database/Sorted_database.bib';
Extract_missing_titles(database_in)
Extract_missing_authors(database_in)
Extract_missing_references(database_in)
Extract_missing_keys(database_in)
Extract_missing_dates(database_in)
Sort_by_dates_and_fix_syntax(database_in, database_out)


