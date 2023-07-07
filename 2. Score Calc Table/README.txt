--phm table is a table created by our data team each month. Containing every patient and hundreds of attributes,
will need to create a similar table containing all the attributes included in the case statements
All the EMIS searches for attributes are in the Attributes folder within the 'EMIS Searches' folder, and population searches in population folder
In the phm table attributes needed for the cambridge score calculation are either 1 (if patient has condition) or null (if not)
apart from cc_egfr which is cast as decimal and max value taken (if multiple values per patient).
  