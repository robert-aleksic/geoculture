# geoculture

## preparing for work
- install libre office from https://www.libreoffice.org/
- install exiftool from https://exiftool.org/
- install freepascal from https://www.freepascal.org/
- install git from https://git-scm.com/
- install ssh and generate rsa key for git accesss (and add ssh key to your github account)
- create geoculture folder and clone geoculture, geoculture_prep and geoculture_data into it (git clone git@github.com:robert-aleksic/geoculturexxx)
- rename folders to site, prep and data respectively
- set utf-8 code page on windows

## geoculture folder structure

- data (excel, points.csv, slikari.csv, images starting with four numbers)
- prep (exif, prep (create poi.js), copyrenamed)
- site (static site contents)

## update procedure

- pull everything from git
  - cd data; git pull; cd ..
  - cd prep; git pull; cd ..
  - cd site; git pull; cd ..

- change folder to data
  - copy excel to data
  - export two sheets to points.csv, slikari.csv in data with libreoffice
    - beware of unclosed quotes, change them to apostrophe if needed i'll sort it out later
    - beware of empty columns

- change folder to prep
  - if needed compile prep.pas (compile.bat)
  - run run.bat, which in turn
    - runs exif for metadata
    - runs prep for poi.js on site
    - runs copyrenamed for images on site

- change folder to site
  - check if site is ok in browser (open index.html file), copmpare with geoculture.me

- push data and site to git
  - cd data; git add .; git commit -m 'update xx/xx/xxx'; git push; cd ..
  - cd site; git add .; git commit -m 'update xx/xx/xxx'; git push; cd ..
