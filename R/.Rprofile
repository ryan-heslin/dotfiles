.libPaths(new = "~/R/x86_64-pc-linux-gnu-library/4.3")

# Set options
local({
    # default_packages <- character()
    # if (!"renv" %in% list.dirs(base::.libPaths()[[1]],
    #   recursive = FALSE, full.names = FALSE
    # ) || is.null(renv::project())) {
    #   default_packages <- character()
    #
    # }
    # Add Nvim-R completion and language server requirements if started with Nvim
    if (Sys.getenv("OS") != "Windows_NT" && !is.null(renv::project())) {
        extra_packages <- c(
            "languageserver", "lintr"
        )
        if (Sys.getenv("NVIMR_TMPDIR") != "") extra_packages <- c(extra_packages, "nvimcom")
    } else {
        extra_packages <- character()
    }
    # if (interactive()) {
    #   require(usethis, quietly = TRUE)
    # }

    options(
        defaultPackages = c(
            getOption("defaultPackages"),
            extra_packages
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

# Update all packages, installing any R thinks are missing
.my_funs$update_packages <- function() {
    ok <- FALSE
    handler <- function(e) {
        install.packages(e[["package"]], ask = FALSE)
        ok <<- FALSE
    }

    while (!ok) {
        ok <- TRUE
        tryCatch(update.packages(), error = handler)
    }
}

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


.my_funs$google <- function(query) {
    browseURL(paste0("http://www.google.com/search?q=", query))
}
# Google most recent error message
.my_funs$search_error <- function() {
    error <- capture.output(cat(geterrmessage()))[[1]]
    google(error)
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
