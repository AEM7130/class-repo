#!/bin/sh

# Create the files
for i in {1..5000}
do
  touch file-$i.txt
done

echo "Done making the files."

# Add the rows to each file
for i in {1..5000}
do
  head -$i adult.data | tail -1 >> file-$i.txt
done

echo "Done adding rows."

# Rename
for i in {1..5000}
do
  mv file-$i.txt file_$i.txt
done

echo "Done renaming the files."

touch new_data_set.csv

# Recombine
for i in {1..5000}
do
  head -1 file_$i.txt >> new_data_set.csv
done

echo "Done recombining the files."

# Count number of males
grep -c "Male" new_data_set.csv > output.txt

# Count number of unique professions
cut -d "," -f 7 adult.data | sort | uniq -c | wc -l >> output.txt

# Remove files
rm file_* new_data_set.csv
