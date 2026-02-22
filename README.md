# geoculture

* geoculture folder structure

- data (excel, points.csv, slikari.csv, images, starting with four numbers)
- prep (exif, prep (create poi.js), copyrenamed)
- site (static site contents)

* update procedure

- sync with git
  - cd data; git pull
  - cd prep; git pull
  - cd site; git pull

- copy excel to data
- export two sheets to points.csv, slikari.csv in data
  - beware of quotes. change them to apostrophe if needed
  - beware of empty columns

- change folder to prep
- run run.sh (exif, prep and rename)

- change folder to site
- check if site is ok in browser (open index.html file), copmpare with geoculture.me

- sync with git
  - cd data; git add .; git commit -m 'update xx/xx/xxx'; git push
  - cd site; git add .; git commit -m 'update xx/xx/xxx'; git push

