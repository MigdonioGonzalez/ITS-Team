#Loading Libraries
require(xlsx)
require(dplyr)
require(lubridate)
require(ggplot2)
require(reshape2)

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
average_time_aleks <- data.frame("Fecha" = as.Date(colnames(average_time_aleks)), "Minutos_de_Interaccion_Promedio" = as.numeric(as.vector(average_time_aleks[1,])))

#Replace NAs for zeros to compute the actual mean. 
data_estudiantes[is.na(data_estudiantes)] <- 0

#Per day average dataframe (actual averages). Requires Students_Count.R
average_time <- summarise_all(data_estudiantes,sum)/60
average_time <- data.frame("Fecha" = as.Date(colnames(average_time)), "Minutos_de_Interaccion_Total" = as.numeric(as.vector(average_time[1,])))
average_time <- full_join(average_time, students_log, by = "Fecha")
average_time <- mutate(average_time, "Minutos_de_Interaccion_Promedio" = Minutos_de_Interaccion_Total/Total_de_Estudiantes)

#Creating plots.
plot(average_time_aleks$Fecha,average_time_aleks$Minutos_de_Interaccion_Promedio, type = "l", col = "red", xlab = "Día", ylab = "Tiempo Promedio (minutos)")
plot(average_time$Fecha,average_time$Minutos_de_Interaccion_Promedio, type = "l",col = "red", xlab = "Día", ylab = "Tiempo Promedio (minutos)")

#Fancy Plot
##If we are plotting 2 series, ggplot works best with long format
## Basicly we are merging the means from alkes, and the calculated ones and then tranforming them into long format
mergeCols = c("Fecha","Minutos_de_Interaccion_Promedio")
average_time_merge <-merge(average_time[,mergeCols], average_time_aleks[,mergeCols], by = "Fecha",suffixes = c("_real","_aleks"))
average_time_merge.melt = melt(average_time_merge, id = "Fecha",value.name = "Mean", variable.name = "Source")
#gglot
ggplot(aes(Fecha,Mean,color=factor(Source,labels = c("Calculado", "Según Aleks"))), data = average_time_merge.melt) +
  geom_line() +
  labs(y = "Interaccion Promedio (mins)", color = "Fuente") +
  scale_y_continuous(breaks = seq(0,150,20)) +
  ggtitle("Interaccion Promedio vs. Fecha")

##Scatter Plot
ggplot(aes(Fecha,Mean,color=factor(Source,labels = c("Calculado", "Según Aleks"))), data = average_time_merge.melt) +
  geom_point() + 
  geom_smooth(method='lm', se=FALSE) +
  labs(y = "Interaccion Promedio (mins)", color = "Fuente") +
  scale_y_continuous(breaks = seq(0,150,20)) +
  ggtitle("Interaccion Promedio vs. Fecha")
