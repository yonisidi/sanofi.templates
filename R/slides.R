#' @title Create slides template
#' @description Initialize a slide deck template
#' @param deck_name name of the deck
#' @param path Path where to copy files into
#' @param \dots unused
#' @rdname use_slides
#' @export
use_slides <- function(deck_name, path = '.', ...){

slides_script_path <- file.path(path, 'script/analysis/slides', deck_name)

slides_deliv_path  <- file.path('../../../../deliv/presentations', deck_name)
figures_deliv_path <- file.path('../../../../deliv/figures', deck_name)
tables_deliv_path  <- file.path('../../../../deliv/tables', deck_name)

resources_path <- system.file('files/report/root', package = 'sanofi.templates')

template_index <- system.file('files/quarto/slides', package = 'sanofi.templates')

if(!dir.exists(slides_script_path))
  dir.create(slides_script_path, recursive = TRUE)

if(!dir.exists(file.path(slides_script_path, figures_deliv_path)))
  dir.create(file.path(slides_script_path, figures_deliv_path), recursive = TRUE)

if(!dir.exists(file.path(slides_script_path, tables_deliv_path)))
  dir.create(file.path(slides_script_path, tables_deliv_path), recursive = TRUE)

if(!dir.exists(file.path(slides_script_path, slides_deliv_path)))
  dir.create(file.path(slides_script_path, slides_deliv_path), recursive = TRUE)

for(this_dir in c(template_index, resources_path)){
  lapply(list.files(this_dir, full.names = TRUE),
    function(x){
      to_file <- file.path(slides_script_path, basename(x))
      file.copy(x, to_file, overwrite = TRUE)
    })
}

build_yaml(slides_script_path, slides_deliv_path, figures_deliv_path)

}

#' @importFrom yaml write_yaml verbatim_logical
build_yaml <- function(slides_script_path, deliv_path, figure_path){

base_list <- list(
  project = list(
    type = 'default',
    "output-dir" = deliv_path
  ),
  format = list(
    pptx = list(
      "reference-doc" = 'cmei_template.pptx'
    )
  ),
  bibliography = 'references.bib',
  "biblio-style" = 'apalike',
  "link-citations" = TRUE,
  knitr = list(
    opts_chunk = list(
      echo = FALSE,
      message = FALSE,
      warning = FALSE,
      out.width = '95%',
      fig.path = sprintf("%s/", figure_path),
      fig.pos = 'H',
      "fig-format" = 'png',
      fig.align = 'center',
      fig.width = 7L,
      fig.height = 7L,
      dpi = 300L
    )
  )
)

yaml::write_yaml(
  base_list,
  file = file.path(slides_script_path, "_quarto.yaml"),
  handlers = list(logical = yaml::verbatim_logical)
)

}

#' @title Fetch file paths to sage images
#' @description Fetch paths to sage images for using in slides and documents.
#' @param where where in the document
#' @param what type of object
#' @param index index of the object, Default: NULL
#' @return character, path to image
#' @details
#' List of images to select from
#'
#' - Title Page
#'   - title-image
#'   - title-logo
#'
#' - Dividers
#'   - divider-image-1
#'   - divider-image-2
#'   - divider-image-3
#'   - divider-image-4
#'
#' - Side Content
#'   - side-content-1
#'   - side-content-2
#'   - side-content-3
#'   - side-content-4
#'   - side-content-5
#'   - side-content-6
#'
#' - Final Slide
#'   - final-image
#'
#' - Footer Logo
#'   - footer-logo
#'
#' @examples
#'  get_file('title','image')
#'  get_file('divider','image',1)
#'  get_file('divider','image',2)
#' @rdname get_file
#' @export

get_file <- function(where, what, index = NULL){
  if(is.null(index)){
    f <- file.path('files/images',sprintf('%s-%s.png', where, what))
  }else{
    f <- file.path('files/images',sprintf('%s-%s-%s.png', where, what, index))
  }
  system.file(f, package = 'sanofi.templates')
}

