# geoculture install and usage procedure

## preparing for work
- install libre office from https://www.libreoffice.org/
- install exiftool from https://exiftool.org/
- install freepascal from https://www.freepascal.org/
- install git from https://git-scm.com/
- install ssh and generate rsa key for git accesss (and add ssh key to your github account)
- create geoculture folder and clone geoculture, geoculture_prep and geoculture_data into it (git clone git@github.com:robert-aleksic/geoculturexxx)
- rename folders to site, prep and data respectively

## geoculture folder structure
- data (excel, points.csv, slikari.csv, images starting with four numbers)
- prep (exif, prep (create poi.js), copyrenamed)
- site (static site contents)

## update procedure
- go to terminal and change folder to prep
- run _gitpullall_ to get git data to local folders
- prepare csv's
  - copy latest excel to data folder
  - use libreoffice to export sheets to points.csv and slikari.csv in data folder
    _(character set utf-8, separator tab, save cells as shown, quote all text cells)_
- prepare site
  - if needed compile prep.pas (compile.bat)
  - run run.bat, which in turn
    - runs _exif_ for metadata
    - runs _prep_ for poi.js on site
    - runs _copyrenamed_ for images on site
  - check if site is ok in browser (open index.html file from site folde), copmpare with geoculture.me
- when done, push data and site to git
  - cd ../data; git add .; git commit -m 'update xx/xx/xxx'; git push
  - cd ../site; git add .; git commit -m 'update xx/xx/xxx'; git push
  - cd ../prep

## notes
- if _git pull_ fails because of changed files use _git stash_ before _git pull_