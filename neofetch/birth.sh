stat / | awk '/Birth: /{print $2 " " substr($3,1,5)}'
