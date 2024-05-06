source("renv/activate.R")

# obtain list of packages in renv library currently
project <- renv:::renv_project_resolve(NULL)
lib_packages <- names(unclass(renv:::renv_diagnostics_packages_library(project))$Packages)

options(vsc.rstudioapi = TRUE)

if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
  # obtain list of packages in renv library currently
  project <- renv:::renv_project_resolve(NULL)
  lib_packages <- names(unclass(renv:::renv_diagnostics_packages_library(project))$Packages)

  # detect whether key packages are already installed
  # was: !require("languageserver")
  if (!"languageserver" %in% lib_packages) {
    message("installing languageserver package")
    renv::install("languageserver")
  }

  if (!"httpgd" %in% lib_packages) {
    message("installing httpgd package")
    renv::install("nx10/httpgd")
  }

  if (!"vscDebugger" %in% lib_packages) {
    message("installation vscDebugger package")
    renv::install("ManuelHentschel/vscDebugger@v0.4.3")
  }

  # use the new httpgd plotting device
if ("httpgd" %in% .packages(all.available = TRUE)) {
    options(vsc.plot = FALSE)
    options(device = function(...) {
      httpgd::hgd(silent = TRUE)
      .vsc.browser(httpgd::hgd_url(), viewer = "Beside")
    })
  }

}

# cleanup
  rm(list = c('project', 'lib_packages'))
