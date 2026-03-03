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

- pull everything from git or _gitpullall_ from prep folder
  - cd data; git pull; cd ..
  - cd prep; git pull; cd ..
  - cd site; git pull; cd ..

- change folder to data
  - copy excel to data
  - export two sheets to points.csv, slikari.csv in data with libreoffice
    _(character set utf-8, separator tab, save cells as shown, quote all text cells)_

- change folder to prep
  - if needed compile prep.pas (compile.bat)
  - run run.bat, which in turn
    - runs exif for metadata
    - runs prep for poi.js on site
    - runs copyrenamed for images on site

- check if site is ok in browser (open index.html file from site folde), copmpare with geoculture.me

- when done, push data and site to git
  - git -C ../data add .; git -C ../data commit -m 'update xx/xx/xxx'; git push
  - git -C ../site add .; git -C ../site commit -m 'update xx/xx/xxx'; git push
