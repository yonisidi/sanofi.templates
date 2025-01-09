source("renv/activate.R")

repos <- c(
  CRAN = "https://rstudio-pm.prod.p488440267176.aws-emea.sanofi.com/prod-cran/latest",
  INTERNAL = "https://rstudio-pm.prod.p488440267176.aws-emea.sanofi.com/art-git/latest"
)

options(repos = repos)

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
    renv::install("httpgd")
  }

  if (!"startup" %in% lib_packages) {
    renv::install("startup")
  }

  # use the new httpgd plotting device
  if (requireNamespace("httpgd", quietly = TRUE)) {
    options(vsc.plot = FALSE)
    options(device = function(...) {
      httpgd::hgd(silent = TRUE)
      .vsc.browser(httpgd::hgd_url(history = FALSE), viewer = "Beside")
    })
  }
  
  tryCatch(startup::startup(), error = function(ex) message(".Rprofile.error: ", conditionMessage(ex)))

}

Sys.setenv(DENO_TLS_CA_STORE = 'system')

# cleanup
rm(list = c('project', 'lib_packages', 'repos'))
