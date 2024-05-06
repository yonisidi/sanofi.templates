#' @title Create report template
#' @description Initialize a report folder structure via officedown
#' @param report_name name of the report
#' @param path Path where to copy files into
#' @param \dots unused
#' @rdname use_report
#' @export
use_report <- function(report_name, path = '.', ...){

  if(!'glossaries'%in%.packages(all.available = TRUE)){
    renv::install('yonicd/glossaries')
  }

  report_script_path <- file.path(path,'script/report',report_name)

  report_deliv_path <- file.path(path,'deliv/reports',report_name)
  figures_deliv_path <- file.path(path,'deliv/figures',report_name)
  tables_deliv_path <- file.path(path,'deliv/tables',report_name)

  template_index <- system.file('files/report/index',package = 'sanofi.templates')
  template_root <- system.file('files/report/root',package = 'sanofi.templates')
  template_sections <- system.file('files/report/sections',package = 'sanofi.templates')

  if(!dir.exists(report_script_path))
    dir.create(report_script_path,recursive = TRUE)

  if(!dir.exists(figures_deliv_path))
    dir.create(figures_deliv_path,recursive = TRUE)

  if(!dir.exists(tables_deliv_path))
    dir.create(tables_deliv_path,recursive = TRUE)

  if(!dir.exists(report_deliv_path))
    dir.create(report_deliv_path,recursive = TRUE)

  lapply( list.files( template_index, full.names = TRUE ),
          function(x){
            to_file <- file.path( report_script_path, basename(x) )
            file.copy(x, to_file, overwrite = TRUE)
          })

  lapply( list.files( template_root, full.names = TRUE ),
          function(x){
            to_file <- file.path( report_deliv_path, basename(x) )
            file.copy( x, to_file, overwrite = TRUE )
          })

  file.copy( template_sections, report_deliv_path, recursive = TRUE, overwrite = TRUE )

  old_rmd <- file.path(report_script_path, 'index.Rmd')
  new_rmd <- gsub( 'NEW_REPORT', report_name, readLines( old_rmd ) )
  cat( new_rmd, file = old_rmd, sep = '\n' )

}
