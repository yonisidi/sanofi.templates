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

In `RStudio` from the menu bar

1. Choose File from Menu Bar
1. Select "New File"
1. Select "R Markdown ..."
1. Select "From Template"
1. Scroll down to "Sanofi Themed Presentation"
    - Fill in the name of the slide deck file
    - Choose location to save on disk
1. Click `OK`
