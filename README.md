# geoculture

## preparing for work
- install exiftool from https://exiftool.org/
- install freepascal from https://www.freepascal.org/
- install git from https://git-scm.com/
- install ssh and generate rsa key for git accesss (and add ssh key to your github account)
- create geoculture folder and clone geoculture, geoculture_prep and geoculture_data into it (git clone git@github.com:robert-aleksic/geoculturexxx)
- rename folders to site, prep and data respectively


## geoculture folder structure

- data (excel, points.csv, slikari.csv, images, starting with four numbers)
- prep (exif, prep (create poi.js), copyrenamed)
- site (static site contents)

## update procedure

- pull everything from git
  - cd data; git pull
  - cd prep; git pull
  - cd site; git pull

- copy excel to data
- export two sheets to points.csv, slikari.csv in data
  - beware of quotes. change them to apostrophe if needed
  - beware of empty columns

- change folder to prep
- if needed compile prep (fpc -Fuunits prep; delp . units)
- run run.sh (exif, prep and copyrenamed)

- change folder to site
- check if site is ok in browser (open index.html file), copmpare with geoculture.me

- push data and site to git
  - cd data; git add .; git commit -m 'update xx/xx/xxx'; git push
  - cd site; git add .; git commit -m 'update xx/xx/xxx'; git push

