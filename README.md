# book

This is a library of my books. Visit https://mirguest.github.io/book.html to see the final page.

The workflow:
* The books are managed by Calibre and Excels.
* A CSV file is generated from Excels.
* Use script new.sh to load the CSV file and generate json files named with ISBN.
* Use Make to generate the final store.json.

The format of CSV:

    编号,书名,作者,ISBN,价格,京东链接,位置/地点,相对位置,Label
    1    2    3    4    5    6        7         8        9

