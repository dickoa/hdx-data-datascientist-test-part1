### Python 3
from scraperwiki import scrape
from lxml import html, etree
import numpy as np
import pandas as pd

### OIM URL with global figures
url = 'http://missingmigrants.iom.int/latest-global-figures'

### Get the web page in the right format
page = scrape(url)
tree = html.fromstring(page)

### Use tools such /selectorgadget, css inspector or firebugs to get the css
## we chose css for convience we could have chose also xpath
## Select all the tables, currently we have three tables (2016, 2015, 2014)
oim_html_tables = tree.cssselect('table.table')

### Handy function from the Pandas library to turn the html table into DataFrame directly
## index_col parameter because the first is the list of columns name
oim_data = pd.read_html(etree.tostring(oim_html_tables[1], method = 'html'), index_col = 0)[0]

### Small data cleaning before exporting the data
## Convert all non numeric to NA
oim_data = oim_data.replace("-", np.nan, regex = True)

## Replace NA by zero
oim_data = oim_data.fillna(0)

### Save it
oim_data.to_csv("data/oim_data_latest.csv")

### Add metadata 
### http://docs.hdx.rwlabs.org/providing-metadata-for-your-datasets-on-hdx/
metadata = {'location' : 'World',
            'source'   : 'International Organization for Migration',
            'date of dataset': "2016",
            'comment' : "Scraped from OIM website"}
            
