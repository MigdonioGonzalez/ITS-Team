GetPlacementReport <- function(inicial = "",final = ""){
  username <- ""
  username <- paste0("username=",username)
  
  password <- ""
  password <- paste0("password=",password)
  
  class_code <- ""
  class_code <- paste0("class_code=",class_code)
  
  inicial <- paste0("from_date=",inicial)
  final <- paste0 ("to_date=", final)
  
  prep <- paste0("show_prep=true")
  
  type <- "all"
  type <- paste0("type=",type)
  
  URL <- "https://api.aleks.com/urlrpc?method=getPlacementReport"
  URL <- paste(URL,username,password,class_code,inicial,final,type,prep,sep="&")
  URL <- paste0(URL,"&page_num=1")
  
  data_estudiantes <- read.csv(URL,encoding = "UTF-8")
  View(data_estudiantes)
  
  return(data_estudiantes)
}