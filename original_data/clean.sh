# Remove # signs from files
for file in $(ls *.txt); do cat $file | sed 's/#//' > fix_$file; done
rm content*.txt
for file in $(ls *.txt); do NEW=$(echo $file | cut -f3 -d\_); NEW="content_$NEW"; mv $file $NEW; done

