#Columna de número de estudiantes en el módulo y decimales significativos. 
#Loading Libraries
library(xlsx)
library(dplyr)
library(lubridate)

#Reading the student's data.
data_estudiantes <- read.xlsx('Time_and_Topic.xlsx',1)

#Cleaning the data.
data_estudiantes <- data_estudiantes[,-(1:9)] 
data_estudiantes <- data_estudiantes[,-which( (data_estudiantes[3,] == "learned") | (data_estudiantes[3,] == "attempted") )]
data_estudiantes <- data_estudiantes[-c(1,2,3),]
colnames(data_estudiantes) <- seq(as.Date("2018/3/21"), by = "day", length.out = ncol(data_estudiantes))
data_estudiantes[] <- lapply(data_estudiantes, hm)
data_estudiantes[] <- lapply(data_estudiantes, period_to_seconds)

#Per day average dataframe (like Aleks')
average_time_aleks <- summarise_all(data_estudiantes, mean, na.rm = TRUE)/60
average_time_aleks <- data.frame("Fecha" = as.Date(colnames(average_time_aleks)), "Minutos_de_Interacción_Promedio" = as.numeric(as.vector(average_time_aleks[1,])))

#Replace NAs for zeros to compute the actual mean. 
data_estudiantes[is.na(data_estudiantes)] <- 0

#Per day average dataframe (actual averages)
average_time <- summarise_all(data_estudiantes,mean)/60
average_time <- data.frame("Fecha" = as.Date(colnames(average_time)), "Minutos_de_Interacción_Promedio" = as.numeric(as.vector(average_time[1,])))

#Creating plots.
plot(average_time_aleks$Fecha,average_time_aleks$Minutos_de_Interacción_Promedio, type = "l", col = "red", xlab = "Día", ylab = "Tiempo Promedio (minutos)")
plot(average_time$Fecha,average_time$Minutos_de_Interacción_Promedio, type = "l",col = "red", xlab = "Día", ylab = "Tiempo Promedio (minutos)")