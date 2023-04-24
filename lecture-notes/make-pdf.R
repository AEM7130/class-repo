# Makes pdf slides for all lectures
lapply(list.files("lecture-notes", pattern = "*.html", recursive = T, full.names = TRUE)[8], 
       function(file) {
         xaringan::decktape(
           file, 
           output = paste0(tools::file_path_sans_ext(file), ".pdf")
         )
       }
)
