# geoculture

* geoculture folder structure

- data (excel, points.csv, slikari.csv, images, starting with four numbers)
- prep (exif, prep (create poi.js), copyrenamed)
- site (site contents, this archive)

* update procedure

- copy excel to data
- export two sheets to points.csv, slikari.csv in data
  - beware of quotes change them to apostrophe if needed
  - beware of empty columns
- git add .; git commit -m 'message'; git push

- change folder to prep
- git pull
- run run.sh (exif, prep and rename)

- check if site is ok in browser (site/index.html)
- git add .; git commit -m 'message'; git push