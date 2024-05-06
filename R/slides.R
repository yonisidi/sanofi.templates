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
    f <- file.path('files/images',sprintf('%s-%s.png',where, what))
  }else{
    f <- file.path('files/images',sprintf('%s-%s-%s.png',where, what, index))
  }
  system.file(f,package = 'sanofi.templates')
}
