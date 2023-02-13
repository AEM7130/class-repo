#!/bin/bash

# step 1
for i in {1..50}
do
touch file-$i.txt
done

# step 2
for i in {1..50}
do
head -n $i adult.data | tail -1 | cat >> file-$i.txt
done

# step 3
for i in {1..50}
do
mv file-$i.txt file_$i.txt 
done

# step 4
touch new_data_set.csv
for i in {1..50}
do
cat file_$i.txt >> new_data_set.csv
done

# step 5
touch output.txt
grep -w Male new_data_set.csv | wc -l | cat >> output.txt

# step 6 
cut -d ',' -f7  new_data_set.csv | uniq | wc -l | cat >> output.txt

# step 7
for i in {1..50}
do
rm file_$i.txt
done
