# Usage

## Installation

```r
remotes::install_github('yonisidi/sanofi.templates')
```

```r
library(sanofi.templates)
```

## Initializing a new Project

In `RStudio` from the menu bar

1. Choose File from Menu Bar
1. Select "New Project"
1. Select "New Directory"
1. Scroll down to "Sanofi Workspace Template"

## Initializing a new Report

```r
use_report(report_name = 'Name of Report',path = 'Path to place Rmd file')
```

Usage guide: 

* 'Name of Report' will become the directory name of the report
* 'Path to place Rmd file' should be the repo's root directory that contains the `deliv` and `script` directories

## Initializing a new slide deck

### Powerpoint

```r
use_slides(deck_name = 'Name of Deck', path = 'Path to place qmd file')
```

Usage guide: 

* 'Name of Deck' will become the directory name of the slides
* 'Path to place qmd file' should be the repo's root directory that contains the `deliv` and `script` directories
