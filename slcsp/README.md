Calculate second lowest cost silver plan (SLCSP)
================================================

Implementation - Jonathan Perrine
----------------------------------
`lib/slcsp.rb` relies on `plan_book.rb` and `rate_area_book.rb` for csv processing.

`bundle install` will install prerequisites (namely rspec)

To run, use the :calculate_slcsp rake task:

`rake calculate_slcsp`

By default, `rake` runs the Unit test suite in slcsp_tests.spec.rb



Problem
-------

You have been asked to determine the second lowest cost silver plan (SLCSP) for
a group of ZIP Codes.

Task
----

You have been given a CSV file, `slcsp.csv`, which contains the ZIP Codes in the
first column. Fill in the second column with the rate (see below) of the
corresponding SLCSP. Your answer is the modified CSV file, plus any source code
used.

Write your code in your best programming language.

The order of the rows in your answer file must stay the same as how they
appeared in the original `slcsp.csv`.

It may not be possible to determine a SLCSP for every ZIP Code given. Check for cases
where a definitive answer cannot be found and leave those cells blank in the output CSV (no
quotes or zeroes or other text).
