#Loading libraries.
require(xlsx)
require(dplyr)

#Cleaning the data. 
students_list <- read.xlsx("Student_Roster.xls",1)
students_list <- students_list[-1,-c(1:3,7)]
colnames(students_list) <- make.names(as.character(unlist(students_list[1,])))
students_list <- students_list[-1,]
students_list$Enrollment.Date <- as.Date(as.character(students_list$Enrollment.Date), format = "%m/%d/%y")

#Creating the time series and count vector. 
dates_list_day <- seq(as.Date("2018-03-21"), as.Date("2018-04-28"),by = "day")


#Creating the counting function. 
students_count <- function(dates){
  count <- as.numeric()
  for (d in 1:length(dates)){
    count[d] <- nrow(filter(students_list, Enrollment.Date <= dates[d]))
  }
  return(count)
}

#Creating resulting dataframe.
count <- students_count(dates_list_day)
students_log <- data.frame("Fecha" = dates_list_day, "Total_de_Estudiantes" = count)
