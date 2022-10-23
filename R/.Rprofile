.libPaths(new = "~/R/x86_64-pc-linux-gnu-library/4.2")

# Set options
local({
  default_packages <- character()
  if (!"renv" %in% list.dirs(base::.libPaths()[[1]],
    recursive = FALSE, full.names = FALSE
  ) || is.null(renv::project())) {
    default_packages <- character()

  }
  # Add Nvim-R completion and language server requirements if started with Nvim
  if (Sys.getenv("OS") != "Windows_NT") {
    default_packages <- c(
      default_packages, "nvimcom",
      "languageserver", "lintr"
    )
  }
  # if (interactive()) {
  #   require(usethis, quietly = TRUE)
  # }

  options(
    defaultPackages = c(
      getOption("defaultPackages"),
      default_packages
    ),
    echo = TRUE,
    error = utils::recover,
    # scipen = 999,
    shiny.error = utils::recover,
    warnPartialMatchDollar = TRUE,
    warnPartialMatchArgs = TRUE,
    warnPartialMatchAttr = TRUE,
    width = 50
  )
})

.my_funs <- new.env()

.my_funs$q2 <- function() quit(save = "no")

.my_funs$my_theme <- function() {
  local({
    if ("ggplot2" %in% list.dirs(base::.libPaths()[1],
      recursive = FALSE, full.names = FALSE
    )) {
      theme_standard <- ggplot2::theme(
        panel.background = ggplot2::element_blank(),
        panel.border = ggplot2::element_rect(color = "black", fill = NA),
        panel.grid = ggplot2::element_blank(),
        panel.grid.major.x = ggplot2::element_line(color = "gray93"),
        legend.background = ggplot2::element_rect(fill = "gray93"),
        plot.title = ggplot2::element_text(
          size = 15,
          family = "sans",
          face = "bold",
          vjust = 1.3
        ),
        plot.title.position = "plot",
        plot.subtitle = ggplot2::element_text(size = 10, family = "sans"),
        legend.title = ggplot2::element_text(
          size = 10,
          family = "sans",
          face = "bold"
        ),
        axis.title = ggplot2::element_text(
          size = 9,
          family = "sans",
          face = "bold"
        ),
        axis.text = ggplot2::element_text(size = 8, family = "sans"),
        strip.background = ggplot2::element_rect(
          color = "black",
          fill = "black"
        ),
        strip.text.x = ggplot2::element_text(color = "white"),
        strip.text.y = ggplot2::element_text(color = "white")
      )
      ggplot2::theme_set(theme_standard)
    } else {
      message("ggplot2 not installed")
    }
  })
}

.my_funs$knit2dir <-
  function(dir = getwd(),
           out = file.path(dir, "outputs"),
           overwrite = FALSE,
           knit_options = NULL,
           params = NULL,
           envir = NULL) {

    # In case envir is not supplied, create a new environment every iteration
    force(envir)
    get_env <- function(arg) {
      if (is.environment(arg)) {
        function() arg
      } else {
        function() new.env(parent = globalenv())
      }
    }
    envir <- get_env(envir)
    dir <- normalizePath(dir)
    out <- normalizePath(out)

    if (!dir.exists(dir) || !dir.exists(out)) stop()
    errors <- warn <- character()
    extension <- "\\.[rR]md$"
    files <- list.files(
      path = dir, pattern = extension, full.names = TRUE,
      include.dirs = FALSE
    )
    if (!overwrite) {
      # Ignore files already rendered
      files <- files[!tools::file_path_sans_ext(basename(files)) %in%
        tools::file_path_sans_ext(basename(list.files(out)))]
    }
    if (length(files) == 0) {
      message("No files found to render")
      return()
    }

    # Knit each file in fresh environment, catching errors
    for (file in files) {
      withCallingHandlers(
        {
          rmarkdown::render(
            input = file,
            output_dir = out,
            output_options = knit_options,
            params = params,
            envir = envir()
          )
        },
        error = function(e) {
          errors <<- c(errors, setNames(conditionMessage(e), file))
          invisible(NULL)
        },
        warning <- function(w) {
          warn <<- c(warn, setNames(conditionMessage(w), file))
          invisible(NULL)
        }
      )
    }
    message(
      "There were",
      n_errors <- length(errors),
      "error(s) and",
      n_warn <- length(warn),
      "warnings out of",
      length(files),
      "file(s)"
    )
    if (n_errors > 0) {
      message("Errors:", paste(names(errors), errors, sep = ": "))
    }
    if (n_warn > 0) {
      message("Warnings:", paste(names(warn), warn, sep = ": "))
    }
  }





.my_funs$source2 <- function(...) {
  source(..., echo = TRUE)
}


.my_funs$clear <- function(envir = parent.frame()) rm(list = ls(envir = envir))



.my_funs$test_print_sections <- function() {
  system("rm test.Rmd")
  draft2("test.Rmd", "notes_text", list(a = 1, b = 2, c = 0, d = list(e = 5, 2)))
}
.my_funs$print_sections <- function(lst, lst_names = dummy_name(lst), file, depth = 1) {
  mapply(\(x, y){
    if (nzchar(y)) {
      cat(file = file, paste(paste(rep("#", depth), collapse = ""), y), sep = "\n\n", append = TRUE)
      cat("\n", file = file, append = TRUE)
    }
    if (is.list(x)) {
      print_sections(x, dummy_name(x), file = file, depth = depth + 1)
    } else {
      # Cat name if not empty string, then section numbers
      to_print <- if (x %in% letters) {
        letters[seq_len(which(letters == x))]
      } else if (is.numeric(x) && x > 0) {
        seq_len(x)
      } else {
        character()
      }
      if (length(to_print)) {
        cat(
          file = file, paste0(paste(rep("#", times = depth + 1), collapse = ""), " ", to_print, "."), sep = "\n\n\n",
          append = TRUE
        )
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
  if (!is.null(numbered_sections)) {
    print_sections(numbered_sections, file = file)
  }
  if (open) {
    if (Sys.getenv("OS") == "Windows_NT") {
      rstudioapi::navigateToFile(file)
    } else {
      system2("nvim", args = file)
    }
  }
}

# rmarkdwon::draft modified to overwrite tempalte files if they already exist
.my_funs$force_draft <- function(file,
                                 template,
                                 package = NULL,
                                 create_dir = "default",
                                 edit = TRUE) {
  # resolve package file
  if (!is.null(package)) {
    template_path <- system.file("rmarkdown", "templates", template,
      package = package
    )
    if (!nzchar(template_path)) {
      stop(
        "The template '",
        template,
        "' was not found in the ",
        package,
        " package"
      )
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
  if (identical(create_dir, "default")) {
    create_dir <- isTRUE(template_meta$create_dir)
  }

  # create a new directory if requested
  if (create_dir) {
    # remove .Rmd extension if necessary
    file <- xfun::sans_ext(file)

    # create dir (new dir only)
    if (dir_exists(file)) {
      stop("The directory '", file, "' already exists.")
    }
    dir.create(file)

    # reconstitute the file path
    file <- file.path(file, basename(file))
  }

  # Ensure we have an Rmd extension
  if (!identical(tolower(xfun::file_ext(file)), "rmd")) {
    file <- paste(file, ".Rmd", sep = "")
  }

  # Ensure the file doesn't already exist
  if (file.exists(file)) {
    stop("The file '", file, "' already exists.")
  }

  # copy all of the files in the skeleton directory
  skeleton_files <- list.files(file.path(template_path, "skeleton"),
    full.names = TRUE
  )
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
  if (edit) {
    utils::file.edit(normalizePath(file))
  }

  # return the name of the file created
  invisible(file)
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
    decreasing = TRUE
  )[1L],
  start = 1,
  stop = 2
  )
  if (is.na(latest)) {
    message(
      "No files in directory",
      dir,
      "matched pattern",
      pat,
      "Defaulting to 01"
    )
    latest <- "01"
  }
  sprintf("%02d", as.numeric(latest) + 1)
}

.my_funs$create_next <-
  function(dir = ".",
           name,
           pat = "^\\d",
           template = "notes_text") {
    expr <- bquote(
      {
        file <- paste0(
          next_prefix(dir = ".", pat = .(pat)),
          "_",
          stringr::str_extract(getwd(), "[^/]+$"),
          "_",
          .(name),
          ".Rmd"
        )
        draft2(file = file, template = .(template))
      },
      splice = TRUE
    )

    with_dir(expr = eval(expr), dir = dir)
  }

.my_funs$google <- function(query) {
  browseURL(paste0("http://www.google.com/search?q=", query))
}
# Google most recent error message
.my_funs$search_error <- function() {
  error <- capture.output(cat(geterrmessage()))[[1]]
  google(query)
}

# These next copied from Advanced R
.my_funs$dump_and_quit <- function() {
  # Save debugging info to file last.dump.rda
  dump.frames(to.file = TRUE)
  # Quit R with error status
  q(status = 1)
}

.my_funs$rmarkdown_error <- function() {
  sink()
  recover()
}

# Prints names and values of its arguments
.my_funs$print_debug <- function(...) {
  dots <- list(...)
  arg_names <- sapply(as.list(substitute(dots)[-1L]), deparse)
  mapply(
    \(x, y){
      cat(y, ": ", sep = "")
      print(x)
    },
    dots, arg_names
  )
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
      mapply(
        FUN = eval(parse(text = paste0(
          tolower(out), "::write", out
        ))),
        imgs,
        targets[!file.exists(targets)],
        SIMPLIFY = FALSE
      )
    }
    knitr::include_graphics(targets)
  }

.my_funs$split_vec <- function(len, per) {
  rep(1:((len %/% per) + (len %% per != 0)), each = per)
}

# Generate snippet for n x m matrix


.my_funs$install.packages2 <- function(package) {
  install.packages(package, dependencies = TRUE, INSTALL_opts = "--no-lock")
}

.my_funs$install2 <- function(package = ".") devtools::install(package, args = "--no-lock")
# Shortcut to toggle `recover` error handler
# From https://jozef.io/r903-tricks-bracketless/
.my_funs$gg <- structure(FALSE, class = "debuggerclass")
.my_funs$print.debuggerclass <- function(debugger) {
  if (!identical(getOption("error"), as.call(list(utils::recover)))) {
    options(error = recover)
    message("Traceback debugging enabled: option 'error' set to `utils::recover`")
  } else {
    options(error = NULL)
    message("Traceback debugging disabled: option 'error' set to NULL")
  }
}
registerS3method("print", "debuggerclass", .my_funs$print.debuggerclass)

# Return elements containing vectors  of differing length

# Copy dependencies of a package to another directory
.my_funs$populate_library <- function(package, target_dir = getwd(),
                                      target_lib = .libPaths()[[1]],
                                      ignore_core = TRUE) {
  info <- packageDescription(package, fields = c("Depends", "Imports"))
  if (length(info) == 1 && is.na(info)) stop(package, " is not installed")
  core_packages <- c(
    "base", "compiler", "datasets", "grDevices",
    "graphics", "grid", "methods",
    "parallel", "splines", "stats", "stats4", "tcltk", "tools", "utils"
  )
  target_dir <- normalizePath(target_dir, mustWork = FALSE)
  target_lib <- normalizePath(target_lib, mustWork = TRUE)
  if (!dir.exists(target_dir)) dir.create(target_dir)
  info[["Depends"]] <- gsub("^R\\s\\(.*", "", info[["Depends"]])
  needed <- unlist(info, use.names = FALSE) |>
    gsub(pattern = "\\s*\\([^)]*\\)\\s*", replacement = "") |>
    strsplit(split = "\\s*,\\s+") |>
    unlist(use.names = FALSE)
  # Don't copy packages included with most R distributions
  if (ignore_core) needed <- needed[!needed %in% core_packages]
  paths <- file.path(target_lib, needed)
  paths <- paths[paths %in% list.dirs(target_lib)]

  file.copy(paths, to = target_dir, overwrite = TRUE, recursive = TRUE)
}
tryCatch(
  {
    repeat detach(.my_funs)
  },
  error = function(e) invisible(NULL)
)
attach(.my_funs)
