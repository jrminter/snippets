view <- function(data, autofilter=TRUE, open_command='xdg-open') {
    # Jeromy Anglim
	# http://jeromyanglim.tumblr.com/post/33825729070/function-to-view-r-data-frame-in-spreadsheet
	# place in .Rprofile
    # data: data frame
    # autofilter: whether to apply a filter to make sorting and filtering easier
    # open_command: command used to open xlsx file
    #     on Ubuntu this `xdg-open` works
    #     on other platforms, perhaps `open` 
    #     or the command name for the spreadsheet softare might work
    require(XLConnect)
    temp_file <- paste0(tempfile(), '.xlsx')
    wb <- loadWorkbook(temp_file, create = TRUE)
    createSheet(wb, name = "temp")
    writeWorksheet(wb, data, sheet = "temp", startRow = 1, startCol = 1)
    if (autofilter) setAutoFilter(wb, 'temp', aref('A1', dim(data)))
    saveWorkbook(wb, )
    system(paste(open_command, temp_file))
}
