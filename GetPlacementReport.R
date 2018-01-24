GetPlacementReport <- function(inicial = "09-01-2017",final = "12-31-2017"){
  username <- "USERNAME"
  username <- paste0("username=",username)
  
  password <- "PASSWORD"
  password <- paste0("password=",password)
  
  class_code <- "CLASSCODE"
  class_code <- paste0("class_code=",class_code)
  
  inicial <- paste0("from_date=",inicial)
  final <- paste0 ("to_date=", final)
  
  type <- "last"
  type <- paste0("type=",type)
  
  URL <- "https://api.aleks.com/urlrpc?method=getPlacementReport"
  URL <- paste(URL,username,password,class_code,inicial,final,type,sep="&")
  URL <- paste0(URL,"&page_num=1")
  
  data_estudiantes <<- read.csv(URL,encoding = "UTF-8")
  View(data_estudiantes)
}