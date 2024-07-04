local languages = { "r", "python" }
local g = vim.g
g.rout_follow_colorscheme = 1
g.markdown_fenced_languages = languages
g.rmd_fenced_languages = languages
g.Rout_more_colors = 1
-- Disable default assign shortcut
g.R_buffer_opts = "winfixwidth nonumber"
g.R_editing_mode = "vi"
g.R_csv_app = "terminal:vd"
g.R_clear_line = 1
g.R_rmd_environment = "new.env()"
g.R_assign = 0
g.R_nvimpager = "vertical"
g.R_rmdchunk = 2 --"``"
g.R_objbr_openlist = 1
g.R_hifun_globenv = 2
g.R_set_omnifunc = {}
g.R_auto_omni = {}
g.R_Rconsole_width = 15
g.R_nvim_wd = 1
g.R_min_editor_width = 15
g.R_openpdf = 1

-- Experimental
--g.R_esc_term = 0
g.R_objbr_w = 30
g.R_objbr_openlist = 1
g.R_objbr_opendf = 1
g.R_args = { "--no-save", "--no-restore-data", "--quiet" }
g.R_start_libs = vim.fn.system("rlib")
g.R_bracketed_paste = 1
g.R_rmd_environment = "new.env()"
g.R_openhtml = 1
g.R_fun_data_1 =
{ "select", "rename", "mutate", "filter", "summarize", "reframe" }
g.R_csv_app = "terminal:vd"
