#' @importFrom yaml read_yaml
#' @importFrom withr with_dir
#' @importFrom renv init
project_template <- function(path, ...) {

  # ensure path exists
  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  dir_list <- yaml::read_yaml(system.file('files/structure.yml', package = 'sanofi.templates'))

  # create dir structure
  invisible(mapply(function(root, stem, path){
      f <- file.path(path, root, stem)
      lapply(f,function(x) {
        dir.create(x,recursive = TRUE)
        file.create(file.path(x, 'empty.txt'))
      })
    },
    names(dir_list),dir_list, MoreArgs = list(path = path))
  )

  file.copy(system.file('files/.gitignore',package = 'sanofi.templates'),file.path(path,'.gitignore'))

  file.copy(system.file('files/utils.R',package = 'sanofi.templates'),file.path(path,'script/utils.R'))

  if(!'renv'%in%.packages(all.available = TRUE)){
    install.packages('renv')
  }

  file.copy(system.file('files/.Rprofile',package = 'sanofi.templates'),file.path(path,'.Rprofile'))
  
  dots <- list(...)
  
  if(nzchar(dots$gh)){

    system('git init')
    system(sprintf('git remote add origin %s', dots$gh))

  }
  
  withr::with_dir(path, renv::init())

}

#' @title Initialize Workspace
#' @description Initialize workspace for a Sanofi project folder
#' @param path Path where to copy files into
#' @param gh url of github repo that you want to associate with the project
#' @rdname init_workspace
#' @export
init_workspace <- function(path = '.', gh = ''){
  project_template(path, gh)
}
