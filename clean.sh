# Same as process.sh only doesn't retrieve new scraping, just begins cleaning from content_final.txt

# cut off beginning of file and remove all <p> tags
sed -n -E -e '/Lancaster County Probation/,$ p' content.txt.out \
| sed '1 d' \
| sed 's/#//' \
| awk '{gsub(/<[^>]*>/,"\n"); print }' \
| awk '{gsub(/#comp-ijeyuhbq/, "\n"); print }' \
| awk '{gsub(/.label:hover h2{text-decoration:underline}/, "\n"); print }' \
| grep -v "^ #MediaLeftPage" \
| sed -n -E -e '/© 2023 by Business Solutions/,$ p' \
| grep -v "^Read More" \
| grep . \
| grep -v '^|' \
| grep -v '^Error' \
| grep -v '^Older' \
| grep -v '^If groups' \
| grep -v '^  https' \
| grep -v '^©' \
| grep -v '^District' \
| grep -v '^Please reload' \
| grep -v 'Newer Posts' \
| grep -v '^Daily Drug Testing Groups' \
| grep -vi '^January' \
| grep -vi '^February' \
| grep -vi '^some elements' \
| grep -vi '^March' \
| grep -vi '^April' \
| grep -vi '^May' \
| grep -vi '^June' \
| grep -vi '^July' \
| grep -vi '^August' \
| grep -vi '^Sept' \
| grep -vi '^October' \
| grep -vi '^November' \
| grep -vi '^December' \
| grep -v '^Call-in Line' \
| sed 's\#\\' \
| cut -f1 -d"-" > content_final.txt


for i in {1..50}
do
	echo Scraping page $i
	# extract raw HTML
	phantomjs process.js $i > content.html

	# remove extra tags and arguments from HTML
	python process.py content.html

	# cut off beginning of file and remove all <p> tags
	sed -n -E -e '/Lancaster County Probation/,$ p' content_final.txt \
	| sed '1 d' \
	| awk '{gsub(/<[^>]*>/,"\n"); print }' \
	| awk '{gsub(/#comp-ijeyuhbq/, "\n"); print }' \
	| awk '{gsub(/.label:hover h2{text-decoration:underline}/, "\n"); print }' \
	| grep -v "^ #MediaLeftPage" \
	| sed -n -E -e '/© 2023 by Business Solutions/,$ p' \
	| grep -v "^Read More" \
	| grep . \
	| grep -v '^|' \
	| grep -v '^Error' \
	| grep -v '^Older' \
	| grep -v '^If groups' \
	| grep -v '^  https' \
	| grep -v '^©' \
	| grep -v '^District' \
	| grep -v '^Please reload' \
	| grep -v 'Newer Posts' \
	| grep -v '^Daily Drug Testing Groups' \
	| grep -vi '^January' \
	| grep -vi '^February' \
	| grep -vi '^March' \
	| grep -vi '^April' \
	| grep -vi '^May' \
	| grep -vi '^June' \
	| grep -vi '^July' \
	| grep -vi '^August' \
	| grep -vi '^Sept' \
	| grep -vi '^October' \
	| grep -vi '^November' \
	| grep -vi '^December' \
	| grep -v '^Call-in Line' \
	| cut -f1 -d"-" >> content_final.txt

done

# use gcsplit to divide days into individual files
echo Splitting into inidividual files
gawk -v RS="Drug" 'NF{ print RS$0 > "./data/content_"++n".txt" }' content_final.txt
