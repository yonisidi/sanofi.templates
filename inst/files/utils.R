groups_slice <- function(.data, ..., .keep_groups = FALSE){
  
  grps <- .data%>%dplyr::group_keys()%>%names()
  
  ret <- .data%>%
    tidyr::nest()%>%
    dplyr::ungroup()%>%
    dplyr::slice(...)%>%
    tidyr::unnest(c(data))
  
  if(.keep_groups)
    ret <- ret%>%dplyr::group_by(!!!rlang::syms(grps))
  
  ret
}

groups_sample <- function(.data,n, .keep_groups = FALSE){
  
  grps <- .data%>%dplyr::group_keys()%>%names()
  
  ret <- .data%>%
    tidyr::nest()%>%
    dplyr::ungroup()%>%
    dplyr::slice_sample(n = n)%>%
    tidyr::unnest(c(data)) 
  
  if(.keep_groups)
    ret <- ret%>%dplyr::group_by(!!!rlang::syms(grps))
  
  ret
}

tidy_labels <- function(.data){
  .data%>%
    labelled::var_label()%>%
    tibble::enframe()%>%
    tidyr::unnest(c(value))
}

grepl_date <- function(x,date_format){
  !is.na(lubridate::parse_date_time(x,date_format,exact = TRUE,quiet = TRUE))
} 

#' @title tidy prop tables
#' @description Create proportion tables the tidy way
#' @param .tbl tibble
#' @param .counts column names to count
#' @param .prop column name to evaluate [prop.table][base::prop.table] on
#' @param .by column names to stratify on, Default: NULL
#' @param drop_n logical, remove cell count column from output, Default: FALSE
#' @param format_prop function, format function to apply to prop column, 
#'  Default: function(x,n) identity(x)
#' @examples 
#' 
#' # percent of gear levels
#' 
#' prop_table(mtcars,
#' .counts = dplyr::vars(gear),
#' .prop = dplyr::vars(gear)
#' )
#' 
#' # percent of gear levels within vs levels
#' 
#'  prop_table(mtcars,
#'  .counts = dplyr::vars(vs,gear),
#'  .prop = dplyr::vars(vs)
#'  )
#'  
#'  # percent of gear levels within vs by am levels
#'  
#'  prop_table(mtcars,
#'  .counts = dplyr::vars(vs,gear),
#'  .prop = dplyr::vars(vs),
#'  .by   = dplyr::vars(am)
#'  )
#'  
#'  # no n column in output
#'  
#'  prop_table(mtcars,
#'  .counts = dplyr::vars(vs,gear),
#'  .prop = dplyr::vars(vs),
#'  .by   = dplyr::vars(am),
#'  drop_n = TRUE
#'  )
#'  
#'  # format prop column
#'  
#'  prop_table(mtcars,
#'  .counts = dplyr::vars(vs,gear),
#'  .prop = dplyr::vars(vs),
#'  .by   = dplyr::vars(am),
#'  format_prop = scales::percent
#'  )
#'  
#'  # fancy format prop column
#'  
#'  prop_table(mtcars,
#'  .counts = dplyr::vars(vs,gear),
#'  .prop = dplyr::vars(vs),
#'  .by   = dplyr::vars(am),
#'  format_prop = function(x,n) glue::glue('{n} ({scales::percent(x)})'),
#'  drop_n = TRUE
#'  )
#'  
#'  
#'  
#' @import dplyr
#' @importFrom tidyr nest unnest
#' @importFrom purrr map
prop_table <- function(
  .tbl,
  .counts,
  .prop, 
  .by = NULL,
  drop_n = FALSE,
  format_prop = function(x,n) identity(x),
  fancy_prop = FALSE,
  sep = '%%SPLIT%%'){
  
  if(fancy_prop){
    format_prop <- function(x,n) glue::glue('{n} ({scales::percent(x)})')
  }
  
  fun <- function(.tbl, .counts, .prop, format_prop){
    
    group_vars <- setdiff(.prop,.counts)
    
    .tbl%>%
      dplyr::count(!!!.counts)%>%
      dplyr::group_by(!!!group_vars)%>%
      dplyr::mutate(prop = format_prop(prop.table(n),n))%>%
      dplyr::ungroup()
    
  }
  
  if(!is.null(.by)){
    
    suppressWarnings({
      suppressMessages({
        

          ret <- .tbl%>%
            tidyr::unite('SPLIT_COL',!!!.by,sep=sep)%>%
            split(.$SPLIT_COL)%>%
            purrr::map_df(.f = fun, .counts, .prop, format_prop,.id = 'SPLIT_COL')%>%
            tidyr::separate(SPLIT_COL,sapply(lapply(.by,rlang::quo_get_expr),as.character,USE.NAMES = FALSE),
                            sep=sep)

        
      })
    })
  }else{
    
    ret <- fun(.tbl, .counts, .prop, format_prop)
    
  }
  
  if(drop_n)
    ret <- ret%>%
      dplyr::select(-n)
  
  ret
  
}

ggpreview <- function(x, w = 5, h = 5, dpi = 150){
  tmp <- tempfile(fileext = '.png')
  grDevices::png(filename = tmp,
                 width = w,
                 height = h,
                 res = dpi,
                 units = 'in')
  print(x)
  grDevices::dev.off()
  viewer <- getOption("viewer")
  viewer(tmp)
}
