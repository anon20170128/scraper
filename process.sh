# extract raw HTML
phantomjs test.js > content.html

# remove extra tags and arguments from HTML
python process.py content.html

# cut off beginning of file and remove all <p> tags
sed -n -E -e '/Lancaster County Probation/,$ p' content.html.out | sed '1 d' | awk '{gsub(/<[^>]*>/,"\n"); print }'  > content_final.txt

# remove junk
cat content_final.txt | awk '{gsub(/#comp-ijeyuhbq/, "\n"); print }' > content_final_2.txt
cat content_final_2.txt | awk '{gsub(/.label:hover h2{text-decoration:underline}/, "\n"); print }' > content_final_3.txt
cat content_final_3.txt | grep -v "^ #MediaLeftPage" > content_final_4.txt

# cut off beginning of file
cat content_final_4.txt | sed -n -E -e '/© 2023 by Business Solutions/,$ p' > content_final_5.txt

# prettify output
cat content_final_5.txt | grep -v "^Read More" > content_final_6.txt
cat content_final_6.txt | grep . > content_final_7.txt

cat content_final_7.txt | grep -v '^|' | grep -v '^Error' | grep -v '^Older' | grep -v '^If groups' | grep -v '^  https' | grep -v '^©' | grep -v '^District' | grep -v '^Please reload' | grep -v '^Daily Drug Testing Groups' | grep -v '^Call-in Line' > content_final_8.txt

# use gcsplit to divide days into individual files
gawk -v RS="Drug" 'NF{ print RS$0 > "content_"++n".txt" }' content_final_8.txt