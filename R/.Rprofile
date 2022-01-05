
# Set options
local({
  default_packages <- c("my.templates")
  # Add Nvim-R completion if started with Nvim
  if (Sys.getenv("OS") != "Windows_NT") {
    default_packages <- c(default_packages, "nvimcom")
  }
  if (interactive()) {
    require(usethis, quietly = TRUE)
  }

  options(
    defaultPackages = c(getOption("defaultPackages"),
                        default_packages),
    echo = TRUE,
    error = utils::recover,
    #scipen = 999,
    shiny.error = utils::recover,
    warnPartialMatchDollar = TRUE,
    warnPartialMatchArgs = TRUE,
    warnPartialMatchAttr = TRUE,
    width = 50
  )
})

.my_funs <- new.env()

# Convert R function to UltiSnips snippet

.my_funs$q2 <- function() quit(save = "no")

.my_funs$my_theme <- function() {
  theme_standard <- ggplot2::theme(
    panel.background = element_blank(),
    panel.border = element_rect(color = "black", fill = NA),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(color = "gray93"),
    legend.background = element_rect(fill = "gray93"),
    plot.title = element_text(
      size = 15,
      family = "sans",
      face = "bold",
      vjust = 1.3
    ),
    plot.title.position = "plot",
    plot.subtitle = element_text(size = 10, family = "sans"),
    legend.title = element_text(
      size = 10,
      family = "sans",
      face = "bold"
    ),
    axis.title = element_text(
      size = 9,
      family = "sans",
      face = "bold"
    ),
    axis.text = element_text(size = 8, family = "sans"),
    strip.background = element_rect(color = "black", fill = "black"),
    strip.text.x = element_text(color = "white"),
    strip.text.y = element_text(color = "white")
  )
  ggplot2::theme_set(theme_standard)
}

.my_funs$knit2dir <-
  function(dir = ".",
           out = paste(dir, "markdowns", sep = "/"),
           overwrite = FALSE,
           options = NULL,
           params = NULL,
           envir = new.env()) {
    errors <- warn <- character()
    extension <- "\\.[rR]md$"
    files <- list.files(path = dir, pattern = extension)
    if (!overwrite) {
      files <- files[!gsub(extension, "", files) %in% gsub("\\.[^\\/]+", "", list.files(out))]
    }
    if(length(files) == 0){
      cat("No files found to render\n")
      return()
    }
    files <- paste(dir, files, sep = "/")
     
    # Knit each in fresh environment, catching errors
    for (file in files) {
      tryCatch({
          rmarkdown::render(
            input = file,
            output_dir = out,
            output_options = options,
            params = params,
            envir = envir
          )
      },
      error = function(e) {
        errors <<- c(errors, setNames(conditionMessage(e), file))
        invisible(NULL)
      },
      warning <- function(w) {
        warn <<- c(warn, setNames(conditionMessage(w), file))
        invisible(NULL)
      })
    }
    cat(
      "There were",
      n_errors <- length(errors),
      "error(s) and",
      n_warn <- length(warn),
      "warnings out of",
      length(files),
      "file(s)",
      "\n"
    )
    if (n_errors > 0) {
      cat("Errors:", paste(names(errors), errors,  sep = ": "), sep = "\n")
    }
    if (n_warn > 0) {
      cat("Warnings:", paste(names(warn), warn,  sep = ": "), sep = "\n")
    }
  }

.my_funs$switch_project <- function(project, stem = "~/R/Projects"){
  .my_funs$rstudio_wrap(
  expr =tryCatch(rstudioapi::openProject(paste0(stem, "/", project, "/", project, ".Rproj")),
      error = function(e) cat("Project", project, "does not exist\n")), project = NULL, stem = "~/R/Projects")
}


.my_funs$rstudio_wrap <- function(expr,  ..., .env  = globalenv()){
    fun_args <- list(...)
    expr <- substitute(expr)
    fun_body <- bquote({
            if(rstudioapi::isAvailable()){
                .(expr)
            }else{
                cat("RStudio not running\n")
            }
    }, splice = TRUE)
    as.function(c(fun_args, fun_body), envir = .env)
}

.my_funs$unload_all <- function(pkg = loadedNamespaces()) {
  srcpkg <-
    c(
      "base",
      "compiler",
      "datasets",
      "graphics",
      "grDevices",
      "methods",
      "parallel",
      "splines",
      "stats",
      "stats4",
      "tcltk",
      "tools",
      "translations",
      "utils"
    )
  
  # Join vector of loaded namespaces to information on imports and clean by regex
  lookup <-
    merge(data.frame(Package = loadedNamespaces()),
          as.data.frame(available.packages()),
          by = "Package")
  lookup <-
    subset(lookup, !(Package %in% srcpkg) & Package %in% pkg)
  
  # Create list of loaded namespaces, with each element a vector of packages that package imports from
  imports <-
    sapply(gsub("(?:\\s|\n)\\([^)]+\\)|\n", "", lookup$Imports), function(x) {
      x <- setdiff(unlist(strsplit(x, ",\\s?")), srcpkg)
    }
    , USE.NAMES = FALSE)
  
  names(imports) <- lookup$Package
  
  
  # Each iteration, unload namespaces not imported by others, then remove those namespaces from list, until all unloaded
  counter <- 0
  while (length(imports) > 0) {
    not_imported <- setdiff(names(imports), unique(unlist(imports)))
    sapply(not_imported, unloadNamespace)
    imports[intersect(names(imports), not_imported)] <- NULL
    counter <- counter + 1
  }
  cat(
    "It took",
    counter,
    "iterations to unload every indicated namespace. Is this truly necessary?"
  )
}

.my_funs$autolab_plot <- function(call, mapping, ...) {
  call <- rlang::enexpr(call)
  label_plots(
    plot = eval(call, envir = parent.frame()),
    mapping = mapping,
    eval = TRUE,
    ...
  )
}

.my_funs$label_plots <-
  function(plot, mapping, eval = TRUE, ...) {
    ## TODO improve with modifyList
    
    if (!"ggplot" %in% class(plot)) {
      stop("Not a ggplot object")
    }
    vars <- plot$labels
    params <-
      mapping[names(mapping) %in% vars] #filter mapping for layers present in plot
    vars <-
      setNames(params[match(vars, names(params))], names(plot$labels)) %>%
      compact()
    
    out <- make_labels(mapping = vars, ...)
    if (eval) {
      return(plot + out())
    }
    out
  }

.my_funs$make_labels <- function(mapping = NULL, ...) {
  force(mapping)
  partial(labs, !!!mapping, ..., ... =)
}

.my_funs$make_tests <- function(..., eval = FALSE, desc = "") {
  dots <- rlang::enexprs(...)
  
  if (!all(names(dots) %in% ls(
    "package:testthat",
    all.names = TRUE,
    pattern = "^expect_"
  ))) {
    stop("Unknown function")
  }
  args <- purrr::imap(dots, function(args, fun) {
    fun <- ensym(fun)
    subs <- purrr::map_depth(args[-1], 2, ~ rlang::expr(!!.x)) %>%
      map( ~ expr((!!fun)(!!!.x[-1]))) #Convert each arg list to appropriate call
    subs
  }) %>%
    rlang::flatten()
  names(args) <- NULL
  print(args)
  out <- rlang::expr(test_that(!!desc, {
    !!!args
  }))
  
  if (eval) {
    eval(out, envir = parent.frame())
  }
  out
}

#' Extract the Example Code from Documentation
#'
#' @description Given a help page's name, extracts the code in the Examples section and
#' optionally runs it.
#' @param fun The name of a function, or other object with a help page
#' @param ns Namespace to search in. Defaults to base.
#' @param eval Logical. Whether to evaluate the extracted code.
#' @details This funciton first searches for the named onbject in help files for the indicated package, base by defualt.
#' If it fails to find any, it then searches all namespaces for the function. If multiple hlp pages exist across loaded packages,
#' the first wins.
#' @return If eval is FALSE, a langauge object containing the extracted code. If
#' eval is TRUE, nothing.
#' @export
#'
#' @examples

.my_funs$get_examples <-
  function(fun, ns = "base", eval = FALSE) {
    if (fun %in% union(ls(paste0("package:", ns)), names(tools::Rd_db(ns)))) {
      path <-
        help(fun,
             package = eval(bquote(.(ns))),
             try.all.packages = FALSE)
    } else{
      path <- help(fun, try.all.packages = TRUE)
      if (length(path) == 0) {
        return("No documentation for",
               fun,
               "found in any loaded namespace")
      }
      ns <- str_extract(path, "[^/]+(?=/help)")
    }
    
    db <- tools::Rd_db(ns)
    
    #Check all packages if not found
    # Get help page
    #
    regex <-
      paste0("^", stringr::str_extract(path, "[^/]+$"), ".Rd") #avoid partial matching
    man <-
      db[stringr::str_detect(names(db), regex)][[1]] %>%
      purrr::keep(~ "\\examples" %in% attributes(.x)) %>%
      unlist() %>%
      purrr::keep(~ !str_detect(.x, "^(%|#)"))# %>%
    #str_remove#(""\\\\(?=\\{)")
    
    #Extract code
    code <- man %>%
      paste(collapse = " ") %>%
      rlang::parse_exprs() %>%
      {
        rlang::expr({
          !!!{
            .
          }
        })
      }
    
    if (eval) {
      eval(code, envir = rlang::caller_env())
    } else{
      return(code)
    }
  }

#' Capture a FUnction Definition as Text
#'
#' @param fun
#' @param ns
#'
#' @return
#' @export
#'
#' @examples
.my_funs$fun_text <- function(fun, ns = -1) {
  get(as.character(fun), pos = ifelse(ns != -1, as.character(ns), ns)) %>%
    dput() %>%
    capture.output() %>%
    paste(collapse = "\n") %>%
    paste(as.character(fun), "<-", .)
  
}

.my_funs$source2 <- function(...) {
  source(..., echo = TRUE)
}

#' Specify Inner List Lengths for a Nested List of Objects
#'
#' @param lens Numeric vector of lengths for each sublist, starting from the
#' left. Must consist of natural numbers whose sum is a multiple of the number
#' of argument passed to @param ...
#' @param ... Any R objects
#'
#' @return A nested list of the objects passed to @param ..., of the lengths
#' specified by @param lens.
#' @export
#'
#' @examples
.my_funs$spec_sublists <- function(lens = 1, ...) {
  dots <- list(...)
  stopifnot(length(dots) %% sum(lens) == 0 &
              all(lens >= 1) & all(lens %% 1 == 0))
  
  splits <-
    purrr::map2(1:length(lens), lens, ~ rep(.x, each = .y)) %>%
    unlist() %>%
    interaction(., rep(1:(length(dots) %/% sum(lens)), each = sum(lens))) %>%
    unclass()
  
  dots %>% split(splits) %>%
    unname()
  
}

.my_funs$clear <- function(envir = parent.frame()) rm(list = ls(envir = envir))
.my_funs$dput2assign <- function(dat, name) {
  name <- substitute(name)
  bquote(.(name) <- .(dput(dat)))
}

.my_funs$dummy_name <- function(x) if(is.null(names(x))) rep("", length(x)) else names(x)

.my_funs$rm2 <- function(file){
  system2("rm", args = file)
}

.my_funs$test_print_sections <- function(){
  system("rm test.Rmd")
  draft2("test.Rmd", "notes_text", list(a = 1, b = 2, c =0, d = list(e = 5, 2)))
}
.my_funs$print_sections <- function(lst, lst_names = dummy_name(lst), file, depth = 1){
  mapply(\(x, y){
  if(nzchar(y)){
    cat(file = file, paste(paste(rep("#", depth), collapse = ""), y), sep = "\n\n", append = TRUE)
    cat("\n", file = file, append = TRUE)
  }
  if(is.list(x)){
    print_sections(x, dummy_name(x), file = file, depth = depth + 1)
  }else{
    # Cat name if not empty string, then section numbers
        to_print <- if (x %in% letters){
            letters[seq_len(which(letters == x))]
        } else if (is.numeric(x) && x > 0){
            seq_len(x)
        }else{
            character()
        }
      if(length(to_print)){
          cat(file = file, paste0(paste(rep("#", times = depth + 1),collapse = ""), " ", to_print, "."), sep = "\n\n\n",
          append = TRUE)
          cat("\n", file = file, append = TRUE)
      }
      }
}, lst, lst_names)
}

.my_funs$draft2 <- function(file, template, numbered_sections = NULL, open = TRUE) {
  force_draft(
    file = file,
    template = template,
    package = "my.templates",
    edit = FALSE,
    create_dir = FALSE
  )
  if(!is.null(numbered_sections)){
    print_sections(numbered_sections, file = file)
  }
  if (open){
    if(Sys.getenv("OS") == "Windows_NT"){
    rstudioapi::navigateToFile(file)
    }else{
      system2("nvim", args = file)
}
  }
}

#rmarkdwon::draft modified to overwrite tempalte files if they already exist
.my_funs$force_draft <- function(file,
                                 template,
                                 package = NULL,
                                 create_dir = "default",
                                 edit = TRUE) {
  # resolve package file
  if (!is.null(package)) {
    template_path = system.file("rmarkdown", "templates", template,
                                package = package)
    if (!nzchar(template_path)) {
      stop("The template '",
           template,
           "' was not found in the ",
           package,
           " package")
    }
  } else {
    template_path <- template
  }
  
  # read the template.yaml and confirm it has the right fields
  template_yaml <- file.path(template_path, "template.yaml")
  if (!file.exists(template_yaml)) {
    stop("No template.yaml file found for template '", template, "'")
  }
  
  template_meta <- yaml::yaml.load_file(template_yaml)
  if (is.null(template_meta$name) ||
      is.null(template_meta$description)) {
    stop("template.yaml must contain name and description fields")
  }
  
  # see if this template is asking to create a new directory
  if (identical(create_dir, "default"))
    create_dir <- isTRUE(template_meta$create_dir)
  
  # create a new directory if requested
  if (create_dir) {
    # remove .Rmd extension if necessary
    file <- xfun::sans_ext(file)
    
    # create dir (new dir only)
    if (dir_exists(file))
      stop("The directory '", file, "' already exists.")
    dir.create(file)
    
    # reconstitute the file path
    file <- file.path(file, basename(file))
  }
  
  # Ensure we have an Rmd extension
  if (!identical(tolower(xfun::file_ext(file)), "rmd"))
    file <- paste(file, ".Rmd", sep = "")
  
  # Ensure the file doesn't already exist
  if (file.exists(file))
    stop("The file '", file, "' already exists.")
  
  # copy all of the files in the skeleton directory
  skeleton_files <- list.files(file.path(template_path, "skeleton"),
                               full.names = TRUE)
  to <- dirname(file)
  for (f in skeleton_files) {
    file.copy(
      from = f,
      to = to,
      overwrite = TRUE,
      recursive = TRUE
    )
  }
  
  # rename the core template file
  file.rename(file.path(dirname(file), "skeleton.Rmd"), file)
  
  # invoke the editor if requested
  if (edit)
    utils::file.edit(normalizePath(file))
  
  # return the name of the file created
  invisible(file)
}

# Creates a new environment consisting of of the caller environment and objects passed using ...
#' Title
#'
#' @param
#' @param ... Objects in the caller environment. If unnamed, they are named for themselves.
#'
#' @return An environemnt whose parent is the caller environment, with objects passed throguh .. added.
#' @export
#'
#' @examples
.my_funs$env_expand <- function(...) {
  dots <-
    make_selfnamed_list(...) #this unquotes by default - will break if objects passed to make_selfnamed_list aren't in globalenv (parent of the caller env)
  e <- new.env(parent = parent.frame())
  list2env(dots, envir = e)
  e
  on.exit(rm(e)) #clean up
}

#' Borrowed from Advanced R
#'
#' @param expr
#' @param new
#'
#' @return
#' @export
#'
#' @examples
.my_funs$with_dir <- function(expr, dir) {
  if (interactive()) {
    while (!dir.exists(dir)) {
      dir <-
        readline(prompt = paste0("'", dir, "'", " does not exist. Enter correct directory: "))
    }
  } else if (!dir.exists(dir)) {
    stop(dir, "does not exist")
  }
  old <- getwd()
  setwd(dir)
  eval(expr, envir = parent.frame())
  on.exit(setwd(old))
}

#' Generate Non-Distinct Permutations of a Vector
#' https://stackoverflow.com/questions/11095992/generating-all-distinct-permutations-of-a-list-in-r
#' @param vec
#' @param m
#'
#' @return
#' @export
#'
#' @examples
.my_funs$permute_m <- function(m, ..., distinct = FALSE) {
  args <-
    unlist(lapply(list(...), function(x)
      replicate(m, x, simplify = FALSE)),
      recursive = FALSE)
  out <- do.call("expand.grid", args)
  
  if (distinct) {
    out[apply(out, 1, function(x) {
      length(unique(x)) == length(args)
    }), ]
  } else{
    out
  }
}


#allowConsole = FALSE
.my_funs$documentId2 <- function() {
  rstudioapi::documentId(allowConsole = FALSE)
}


#' Close the Last n Open Documents
#'
#' @param n
#'
#' @return
#' @export
#'
#' @examples
.my_funs$close_n <- function(n = Inf) {
  force(n)
  inner <- function() {
    if (n > 0 && !is.null(documentId2())) {
      rstudioapi::documentClose(id = NULL, save = TRUE)
      n <<- n - 1L
      inner()
    }
  }
  inner()
}

#' Quietly Source all Modified Functions in an Environment
#'
#' @param envir
#'
#' @return
#' @export
#'
#' @examples
.my_funs$source_all <- function(envir = globalenv()) {
  invisible(sapply(lsf.str(envir = envir), get))
}

#' Find the Next Numeric File Prefix in a Directory
#'
#' @param dir
#' @param pat
#'
#' @return
#' @export
#'
#' @examples
.my_funs$next_prefix <- function(dir = ".", pat = "^\\d") {
  latest <- substr(sort(list.files(path = dir, pattern = pat),
                        decreasing = TRUE)[1L],
                   start = 1,
                   stop = 2)
  if (is.na(latest)) {
    message("No files in directory",
            dir,
            "matched pattern",
            pat,
            "Defaulting to 01")
    latest <- "01"
  }
  sprintf("%02d", as.numeric(latest) + 1)
}

.my_funs$create_next <-
  function(dir = ".",
           name,
           pat = "^\\d",
           template = "notes_text") {
    expr <- bquote({
      file <- paste0(
        next_prefix(dir = ".", pat = .(pat)),
        "_",
        stringr::str_extract(getwd(), "[^/]+$"),
        "_",
        .(name),
        ".Rmd"
      )
      draft2(file = file, template  = .(template))
    }, splice = TRUE)
    
    with_dir(expr = eval(expr), dir = dir)
  }

.my_funs$google <- function(query){
  browseURL(paste0("http://www.google.com/search?q=", query))
}
# Google most recent error message
.my_funs$search_error <- function(){
  error <- capture.output(cat(geterrmessage()))[1]
  google(query)
}

# Prints names and values of its arguments
.my_funs$print_debug <- function(...){
  dots <- list(...)
  arg_names <- sapply(as.list(substitute(dots)[-1L]), deparse) 
  mapply(\(x, y){  
  cat(y, ": ", sep = "")
  print(x)
  },
  dots, arg_names)
}
#' Remove an Outer List
#'
#' @param l
#'
#' @return
#' @export
#'
#' @examples
.my_funs$strip_list <- function(l) {
  if (is.list(l[[1]]) & length(l) == 1) {
    return(l[[1]])
  } else{
    return(l)
  }
}
#' Convert an Expression to a Function, with Default Argument Support
#'
#' @param expr
#' @param defaults
#'
#' @return
#' @export
#'
#' @examples
#' Consulted https://stackoverflow.com/questions/17751862/create-a-variable-length-alist
.my_funs$gen_expr <- function(expr, ...) {
  expr <- substitute(expr)
  defaults <- list(...)
  syms <- all.names(expr, functions = FALSE, unique = TRUE)
  if (length(setdiff(names(defaults), syms))) {
    stop("Cannot assign default values to arguments not present in function")
  }
  args <-
    setNames(c(rep(list(bquote(
      
    )),
    length(syms)), expr), c(syms, ""))
  args[match(names(defaults), names(args))] <- defaults
  out <- as.function(args)
  environment(out) <- globalenv()
  out
  
}


#' Add Images of PDF Pages to Rmarkdown Documents
#'
#' @param pdf URL or pdf relative path
#' @param pages Pages of PDF to render
#' @param out Output format - png or jpeg
#' @param targets Relative paths to save files of images
#' @param ... Additional arguments to `pdf_render_page`
#'
#' @return
#' @export
#'
#' @examples
.my_funs$inline_pdfs <-
  function(pdf,
           pages = 1,
           out = c("PNG", "JPEG"),
           targets,
           ...) {
    force(pdf)
    # Get output type and filenames
    out <- match.arg(out)
    ext <- paste0(".", tolower(out))
    
    # Add extensions
    targets[!grepl(paste0(ext, "$"), targets)] <-
      paste0(targets[!grepl(ext, targets)], ext)
    
    # Skip if files already exist
    if (!all(file.exists(targets))) {
      imgs <- lapply(pages, pdftools::pdf_render_page, pdf = pdf, ...)
      mapply(FUN = eval(parse(text = paste0(
        tolower(out), "::write", out
      ))),
      imgs,
      targets[!file.exists(targets)],
      SIMPLIFY = FALSE)
    }
    knitr::include_graphics(targets)
    
  }

.my_funs$split_vec <- function(len, per) {
  rep(1:((len %/% per) + (len %% per != 0)), each = per)
}

# Generate snippet for n x m matrix
.my_funs$fill_mat <- function(dims, file = "") {
  #Fill with space and & for LaTeX entry
  mat <-
    matrix(paste0("${", 1:prod(dims), ":", 1:prod(dims), "}"),
           nrow = dims[1],
           byrow = TRUE)
  
  mat <-
    apply(mat, MARGIN = 1, function(x)
      paste0("\t\t", paste(x, collapse = " & ")))
  
  mat <-
    paste0(mat, c(rep("\\\\\\\\", times = length(mat) - 1), "")) #both cat and snippet parse escapes,
  # so we need 2^3 backslashes
  snip <- paste0("snippet ", dims[1], "x", dims[2])
  cat(
    c(snip, "\t\\begin{bmatrix}", mat, "\t\\end{bmatrix}"),
    sep = "\n",
    file = file,
    append = TRUE
  )
}

#' Generate a
#'
#' @param df Name of a dataframe.
#' @param ... Named arguments to `fun`
#' @param fun Function to use. Defualts to `summarize`.
#'
#' @return
#' @export
#'
#' @examples
.my_funs$gen_summarize <- function(df, ..., fun = summarize) {
  df <- rlang::ensym(df)
  fun <- rlang::enexpr(fun)
  args <- rlang::enexprs(...)
  rlang::new_function(
    args = rlang::pairlist2(df = df),
    body = rlang::expr(df %>% (!!fun)(!!!args)),
    env = rlang::global_env()
  )
}

.my_funs$install.packages2 <-function(package){
  install.packages(package, dependencies = TRUE, INSTALL_opts = "--no-lock")
}

.my_funs$install2 <-function(package = ".") devtools::install(package, args = "--no-lock")
# Shortcut to toggle `recover` error handler
# From https://jozef.io/r903-tricks-bracketless/
.my_funs$gg <- structure(FALSE, class = "debuggerclass")
.my_funs$print.debuggerclass <-  function(debugger) {
  if (!identical(getOption("error"), as.call(list(utils::recover)))) {
    options(error = recover)
    message("Traceback debugging enabled: option 'error' set to `utils::recover`")
  } else {
    options(error = NULL)
    message("Traceback debugging disabled: option 'error' set to NULL")
  }
}
registerS3method("print", "debuggerclass", .my_funs$print.debuggerclass)

#Return elements containing vectors  of differing length
.my_funs$differing_lengths <- function(lst) {
  lst[sapply(lst, function(x)
    length(unique(lengths(x))) > 1L)]
}

# My preferred Rmarkdown chunk options
.my_funs$CHUNK_OPTS <-
  list(
    echo = TRUE,
    comment = "",
    fig.pos = "",
    warning = FALSE,
    fig.align = "center"
  )
# Make R prompt print directory relative to HOME, updating
# on directory change
.my_funs$setwd2 <-function(dir){
    home  <- Sys.getenv("HOME")
    setwd(dir)
    options(prompt = paste0(gsub(paste0(home, "/"), "", getwd(), dir), "> "))
}
tryCatch({repeat detach(.my_funs)}, error = function(e) invisible(NULL))
attach(.my_funs)
