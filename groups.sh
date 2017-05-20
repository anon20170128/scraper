# Compile a list of all unique groups

# Concatonate all group listings
for file in $(ls *.txt)
do
	tail +2 $file >> all_groups.txt
done

# Clean and extract unique entries
cat all_groups.txt \
	| grep -vi "^Weekend" \
	| grep -vi "^today" \
	| grep -vi "^There" \
	| grep -vi "^This" \
	| grep -vi "^Sunday" \
	| grep -vi "^Saturday" \
	| grep -vi "^Monday" \
	| grep -vi "^Tuesday" \
	| grep -vi "^Wednesday" \
	| grep -vi "^Thursday" \
	| grep -vi "^Friday" \
	| grep -vi "^Some" \
	| grep -vi "^No" \
	| grep -vi "^Morning" \
	| grep -vi "^Mid" \
	| grep -vi "^If" \
	| grep -vi "^All" \
	| grep -vi "^Mass" \
	| grep -vi "^Happy" \
	| grep -vi "^Drug" \
	| grep -vi "^Door" \
	| grep -vi "^Dis" \
	| sed 's/#//' \
	| sed 's/\ //' \
	| sort -f \
	| uniq -i > group_list.txt
