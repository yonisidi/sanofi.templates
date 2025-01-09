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

  template_index <- system.file('files/quarto/report', package = 'sanofi.templates')
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

  report_yaml(report_script_path, report_deliv_path, figures_deliv_path)

}

#' @importFrom yaml write_yaml verbatim_logical
report_yaml <- function(report_script_path, deliv_path, figure_path){

report_name <- basename(report_script_path)

base_list <- list(
  project = list(
    type = 'default',
    "output-dir" = deliv_path
  ),
  format = list(
    pdf = list(
      toc = TRUE,
      "output-file" = sprintf("%s.pdf", report_name)
    ),
    html = list(
      toc = TRUE,
      "html-math-method" = katex,
      "output-file" = sprintf("%s.html", report_name)
    ),
    docs = list(
      toc = TRUE,
      "output-file" = sprintf("%s.docx", report_name)
    )
  ),
  bibliography = file.path(deliv_path, 'references.bib'),
  "biblio-style" = 'apalike',
  "link-citations" = TRUE,
  glossary = list(
    file = file.path(deliv_path, 'glossary.yml')
  ),
  knitr = list(
    opts_chunk = list(
      echo = FALSE,
      message = FALSE,
      warning = FALSE,
      out.width = '95%',
      fig.path = sprintf("%s/", figure_path),
      fig.pos = 'H',
      dev = 'png',
      fig.align = 'center',
      fig.width = 7L,
      fig.height = 7L,
      dpi = 300L
    )
  )
)

yaml::write_yaml(
  base_list,
  file = file.path(report_script_path, "_quarto.yaml"),
  handlers = list(logical = yaml::verbatim_logical)
)

}