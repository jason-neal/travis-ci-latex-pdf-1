> Update May 2018 Travis is moving open source to travis-ci.com (instead of travis-ci.org). Travis is also now available as GitHub App in the Marketplace. Instructions are updated.

### LaTeX + Git + Travis &rightarrow; release pdf

[![Build Status](https://api.travis-ci.org/PHPirates/travis-ci-latex-pdf.svg?bla)](https://travis-ci.org/PHPirates/travis-ci-latex-pdf)

Write LaTeX, push to git, let Travis automatically build your file and release a pdf automatically to GitHub releases when the commit was tagged.

# Choose your tools

## 1. Miniconda with Tectonic engine

Thanks to [Dan Foreman-Mackey](http://dfm.io/posts/travis-latex/) for writing about Tectonic.
This method does not use the pdflatex engine to compile, but [Tectonic](https://tectonic-typesetting.github.io) which is a fork of XeTeX (thanks to [ShreevatsaR](https://tex.stackexchange.com/users/48/shreevatsar) for pointing this out). 

#### Pro:
* automatically loops TeX and BibTeX as needed, and only as much as needed
* automatically downloads LaTeX packages which are needed
* can generate an index
* fast, because tectonic and packages are cached

#### Con:
* Tectonic does not support the `-shell-escape` flag at the moment (see [tectonic/#38](https://github.com/tectonic-typesetting/tectonic/issues/38)), which is required for example by the minted package. The pdflatex way (below) has been tested to work with the minted package.

Build time example file: 1-2 minutes

Want this? Instructions [below](#tectonic).


## 2. TeX Live with pdflatex

Thanks to [Joseph Wright](https://tex.stackexchange.com/users/73/joseph-wright) who pointed out that they use something based on this setup for LaTeX3 development.

#### Pro:
* Uses pdflatex to compile, this can be a requirement for some cases like the minted package.
* Fast, because of caching.

#### Con:
* You need to specify by hand which packages you need, and some may not be available in the package repository or under different names or with other packages as requirements.
* You need to specify by hand how much times to compile to make sure references, indices and bibtex references work.

Build time example file: 1-2 minutes

Want this? Instructions [below](#pdflatex).

## 3. TeX Live and pdflatex via tinytex with R.

Thanks to [Hugh](https://tex.stackexchange.com/users/18414/hugh) for pointing out this option.

#### Pro:

* Uses pdflatex.
* Automatically installs packages needed

#### Con:
* You need to specify how much times to compile.
* Build time is very long.

Build time example file: 5-8 minutes

Want this? Instructions [below](#tinytex).

## <a name="tectonic">Instructions for building with Tectonic</a>

* Install the Travis GitHub App by going to the [Marketplace](https://github.com/marketplace/travis-ci), scroll down, select Open Source (also when you want to use private repos) and select 'Install it for free', then 'Complete order and begin installation'. 
* Now you should be in Personal settings | Applications | Travis CI | Configure and you can allow access to repositories, either select repos or all repos.
* Copy `1-tectonic/.travis.yml` and specify the right tex file in the `script` section in `.travis.yml`. Also remove the `makeindex` line and the extra `tectonic` call if not using an index.
* Commit and push, you can view your repositories at [travis-ci.com](https://travis-ci.com/).
* For deploying to GitHub releases, see the notes [below](#deploy).

## <a name="pdflatex">Instructions for building with pdflatex and TeX Live</a>

If for some reason you prefer the pdflatex engine with the TeX Live distribution, read on.

This method installs an almost minimal TeX Live installation on Travis, and compiles with pdflatex.
This repo contains:
- The TeX Live install script `texlive_install.sh` including profile `texlive/texlive.profile` (specifies for example the TeX Live scheme)
- A Travis configuration file
- Demonstration LaTeX files in `src/`
- Besides the list of packages that get installed in `texlive_install.sh`, you can see a list of packages in `main.tex` which you can all use with this install.

### Features

* Add the extra packages you use which are not included in the TeX Live basic scheme to the install script.
* The currently used package index is [here](http://ctan.mirrors.hoobly.com/systems/texlive/tlnet/archive/).
* Same for other document classes.
* Supports file inclusion.
* Caches TeX Live and packages, also speeds up build time.
* Works with (at least) BiBTeX.



### How to use continuous integration for your LaTeX?

* * Install the Travis GitHub App by going to the [Marketplace](https://github.com/marketplace/travis-ci), scroll down, select Open Source (also when you want to use private repos) and select 'Install it for free', then 'Complete order and begin installation'. 
  * Now you should be in Personal settings | Applications | Travis CI | Configure and you can allow access to repositories, either select repos or all repos.
* Copy the files in the folder `2-texlive-pdflatex` to your repo, so `.travis.yml`, `texlive_install.sh`, `texlive_packages` and `texlive/texlive.profile`.
* Specify the right tex file in the `.travis.yml`. Possibly you also need to change the folder in `before_script` if not using `src/`.
* Commit and push, you can view your repositories at [travis-ci.com](https://travis-ci.com/).
* If you need additional packages, you can add them to the `texlive_packages` file. An index of existing packages is for example at http://ctan.mirrors.hoobly.com/systems/texlive/tlnet/archive/
(Thanks to [@jason-neal](https://github.com/PHPirates/travis-ci-latex-pdf/pull/6) for improving this)
* Tip from [gvacaliuc](https://github.com/gvacaliuc/travis-ci-latex-pdf): In order to maintain the install scripts in a central repo and link to them, you could also just copy `.travis.yml` and replace
```yaml
install:
 - source ./texlive_install.sh
```
with
```yaml
install:
  - mkdir ../texlive/
  - curl https://raw.githubusercontent.com/PHPirates/travis-ci-latex-pdf/master/2-texlive-pdflatex/texlive/texlive.profile > ../texlive/texlive.profile
  - curl https://raw.githubusercontent.com/PHPirates/travis-ci-latex-pdf/master/2-texlive-pdflatex/texlive_packages > ./texlive_packages
  - curl https://raw.githubusercontent.com/PHPirates/travis-ci-latex-pdf/master/texlive_install.sh > ./texlive_install.sh
  - source ./texlive_install.sh
```
* Preferably you fork this repo so you can maintain your own build files with the right packages.

Note that sometimes `tlmgr` selects a broken mirror to download TeX Live from, so you get an error like `Output was gpg: verify signatures failed: eof`. Restarting the build will probably fix this, it will auto-select a different mirror. (Thanks to [@jason-neal](https://github.com/jason-neal/travis-ci-latex-pdf-texlive/commit/d48a5f92d2394f27371dd32c94a16415de499058) for testing this.)

## <a name="tinytex">Instructions for building with TeX Live and pdflatex via tinytex with R</a>

* * Install the Travis GitHub App by going to the [Marketplace](https://github.com/marketplace/travis-ci), scroll down, select Open Source (also when you want to use private repos) and select 'Install it for free', then 'Complete order and begin installation'. 
  * Now you should be in Personal settings | Applications | Travis CI | Configure and you can allow access to repositories, either select repos or all repos.
* Copy the files in the folder `3-tinytex` to your repo, so `.travis.yml` and `install_texlive.R`.
* Specify the right tex file in `.travis.yml`.
* Commit and push, you can view your repositories at [travis-ci.com](https://travis-ci.com/).
* For deploying to GitHub releases, see the notes [below](#deploy).

## <a name="deploy">To automatically deploy pdfs to GitHub release</a>
### First time setup
* We will generate a GitHub OAuth key so Travis can push to your releases, with the important difference (compared to just gettting it via GitHub settings) that it's encryped so you can push it safely.
* (Windows) [Download ruby](https://rubyinstaller.org/downloads/) and at at end of the installation make sure to install MSYS including development kit.
* Run `gem install travis --no-rdoc --no-ri` to install the Travis Command-line Tool.
### For every new project
* Remove the `deploy` section in the `.travis.yml` or use `--force` in the next command.
* Go to the directory of your repository, open the command prompt (Windows: <kbd>SHIFT</kbd>+<kbd>F10</kbd> <kbd>W</kbd> <kbd>ENTER</kbd>) and run `travis setup releases --pro`. Specify your GitHub credentials, and fill in anything for File to Upload.
* Replace everything below your encryped api key with (changing the path to your pdf file, probably the same folder as your tex file is in)
```yml
  file: 
  - ./src/nameofmytexfile.pdf
  - ./otherfile.pdf
  skip_cleanup: true
  on:
    tags: true
    branch: master
```
* Commit and push.
* If you are ready to release, just tag and push.
* If you want the badge in your readme, just copy the code below to your readme and change the links.

Markdown:
```markdown
[![Build Status](https://api.travis-ci.com/username/reponame.svg)](https://travis-ci.com/username/reponame)
```
reStructuredText:
```rst
.. image:: https://travis-ci.com/username/reponame.svg?branch=master
    :target: https://travis-ci.com/username/reponame
    :alt: Build Status
```
* Probably you want to edit settings on Travis to not build both on pull request and branch updates, and cancel running jobs if new ones are pushed.

#### Notes
* You can tell Travis to skip the build for a certain commit by prefixing the commit message with `[ci skip]`.
* If you want to build a private project, if you are a student you can use [travis-ci.com](https://travis-ci.com). Beware that you need a token to include the build status image in your readme, get the correct url by clicking on the build status on travis-ci.com.
* Otherwise you could try SemaphoreCI, currently they give 100 private builds per month for free. If you do, it would be great if you could report back!

##### References for original setup with pdflatex and TeX Live
I also put some of these instructions on the [TeX Stackexchange](https://tex.stackexchange.com/questions/398830/how-to-build-my-latex-automatically-with-pdflatex-using-travis-ci/398831#398831).

In the end the install script from the original repo was completely rewritten based on the [LaTeX3 build file](https://github.com/latex3/latex3/blob/master/support/texlive.sh).

Some original thoughts from [harshjv's blog](https://harshjv.github.io/blog/setup-latex-pdf-build-using-travis-ci/), and thanks to [jackolney](https://github.com/jackolney/travis-ci-latex-pdf) for all his attempts to put it into practice.
Also see harshjv's original [blog post](https://harshjv.github.io/blog/document-building-versioning-with-tex-document-git-continuous-integration-dropbox/).
