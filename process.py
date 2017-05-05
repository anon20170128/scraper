from bs4 import BeautifulSoup as bs
import sys

def _remove_attrs(soup):
	for tag in soup.findAll(True): 
		tag.attrs = None
	return soup

with open(sys.argv[1]) as f:
	doc = bs(f, 'html.parser')

invalid_tags = ['b', 'i', 'u', 'script', 'div', 'noscript', 'a', 'iframe', 'span', 'em', 'strong', 'h2', 'style', 'h1']

done = _remove_attrs(doc)

for tag in invalid_tags: 
    for match in done.findAll(tag):
        match.replaceWithChildren()

filename = sys.argv[1]+".out"

with open(filename, 'w') as f:
	f.write(str(done))

	