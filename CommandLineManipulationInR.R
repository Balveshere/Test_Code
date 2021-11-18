#### SETUP CloudCompare ####
#What is your operating system? #keep
#OS<-"mac" 
OS<-"windows" 

#Is CloudCompare already in the PATH? #keep
PATH = FALSE

#If not in the PATH, what directory? #remove
#Edit path to CloudCompare in quotes.

#Mac - if path not set and OS is mac then set path to below... #remove
if(!PATH & OS=='mac') cc_dir = 
  
  #"/Applications/CloudCompare.app/Contents/MacOS/CloudCompare"
  #'/Users/aestoval/Desktop/CloudCompare.app/Contents/MacOS/CloudCompare'

#Windows - if path not set and OS is not mac then set path to below (windows)... #keep
if(!PATH & !OS=='mac') cc_dir = 
  
  shQuote('C:\\Program Files\\CloudCompare\\CloudCompare.exe')

# Add the path to your cloud compare executable #keep
if(PATH & OS=='mac') cloudcompare<-'cloudcompare' else cloudcompare <- cc_dir
if(PATH & OS!='mac') cloudcompare<-'cloudcompare' else cloudcompare <- cc_dir
if(OS=="mac") run<-function(x) rstudioapi::terminalExecute(x) else run<-function(x) shell(x, intern = TRUE)

# Test to see if path recognized and correct #keep
cloudcompare

# Set path to DSM folder of tree point clouds #keep - set path to currentDSM to get list of retained tree point clouds for prescription
files<-list.files("E:/FARO_TargetBased/Segmented_Point_Clouds/North_Eagleville_W_NamedStudyTrees") # I think this should be set to input_file for this section

### This section appears to define the function normalCalc which will process a single point cloud ###
normalCalc<-function(input_file){
  
  print(paste("Input gridded point cloud and estimate normals"))
  print(paste("Processing", input_file))
  
  term<-1
  
  term<-run(paste(cloudcompare, # call Cloud Compare. The .exe file folder must be in the system PATH
                  "-SILENT", # don't use GUI
                  "-C_EXPORT_FMT", "ASC", "-PREC", 6, #Set asc as export format
                  "-NO_TIMESTAMP", # don't overwrite file name on export
                  "-O", input_file, #open the subsampled file
                  "-SOR", 10, 2, # run an SOR filter using 10 pts for average and 2 sd removal
                  "-MERGE_CLOUDS", ### added this to merge clouds but likely needs modifiers and may need to do at end
                  "-RASTERIZE -GRID_STEP", 0.05, "-OUTPUT_MESH", ### added this to compute a mesh for C2M (need to load ground cloud from diff location)
                  "-DELAUNAY", "-BEST_FIT", ### added this as alternate way to generate mesh fo C2M
                  "-C2M_DIST", ### added this to height normalize merged cloud but no mesh currently
                  "-CROSS_SECTION {XML parameters file}", ### added this to remove points below 1.3 m but likely needs modifiers
                  "-SAVE_CLOUDS", # save the processed clouds
                  sep = " ")) # use space separator
  
  while (term==1) sys.sleep(10)
}

### This section appears to be set up to run multiple tree point clouds in a loop using normalCalc function ###
for (i in 1:length(files)) normalCalc(files[i]) 


run(paste(cloudcompare, # call Cloud Compare. The .exe file folder must be in the system PATH
                "-SILENT", # don't use the GUI
                "-C_EXPORT_FMT", "ASC", "-PREC", 6, #Set asc as export format
                "-NO_TIMESTAMP", # don't overwrite cloud names
                "-O", "file.xyz", #open the subsampled file
                "-SOR", 10, 2, # filters each tree cloud in folder independently
                "-MERGE_CLOUDS", ### added this to merge clouds but likely needs modifiers and may need to do at end
                "-RASTERIZE -GRID_STEP", 0.05, "-OUTPUT_MESH", ### added this to compute a mesh for C2M (need to load ground cloud from diff location)
                "-DELAUNAY", "-BEST_FIT", ### added this as alternate way to generate mesh fo C2M
                "-C2M_DIST", ### added this to height normalize merged cloud but no mesh currently
                "-CROSS_SECTION {XML parameters file}", ### added this to remove points below 1.3 m but likely needs modifiers
                "-SAVE_CLOUDS", # saves each cloud with a space separator
                sep = " "))

#install
# library(data.table)

for (i in 1:length(files)){
  tree.df<-data.table::fread("path/to/xyz") #read tree
  fwrite("master_cloud.asc", sep = " ", append = TRUE) #add tree to plot
}

#read in master_cloud

#voxelize to 10 cm
#voxelize 1 m

#save the 1 m voxelized cloud


#####logic - my best guess at steps from syntax...
currentDSMFolder <- "C:/Users/Brandon Alveshere/Desktop/WorkingFolder/Ch2_Ch3_CurrentCoding_CSCME_Manipulation/currentDSM/" # establish path to currentDSM (contains only prescribed trees to load)
currentDSMFiles <- list.files(path = currentDSMFolder, full.names = TRUE) # get list of all tabular removed prescriptions for plot
currentDSMFiles <- mixedsort(currentDSMFiles)

### this needs to load all the retained trees in currentDSM via currentDSMFiles (each file is a single tree cloud)
for (file in currentDSMFiles){
run(paste(cloudcompare, # call Cloud Compare. The .exe file folder must be in the system PATH - load all the trees in CC
          "-SILENT", # don't use the GUI
          "-AUTO_SAVE", "OFF", # don't autosave at each step
          "-C_EXPORT_FMT", "ASC", "-PREC", 6, #Set asc as export format
          "-NO_TIMESTAMP", # don't overwrite cloud names
          "-O", "file.xyz", #open the file
          sep = " "))#end for loop after all trees loaded
}
###then I want to merge the loaded tree clouds, then save or retain the merged cloud to feed into height norm etc [x,y,z]         
run(paste(cloudcompare, # call Cloud Compare. The .exe file folder must be in the system PATH - set export format etc; merge all loaded clouds; save merged
          "-SILENT", # don't use the GUI
          "-AUTO_SAVE", "OFF", # don't autosave at each step
          "-C_EXPORT_FMT", "ASC", "-PREC", 6, #Set asc as export format
          "-NO_TIMESTAMP", # don't overwrite cloud names
          "-MERGE_CLOUDS", ### added this to merge clouds but likely needs modifiers and may need to do at end
          "-SAVE_CLOUDS", "FILE", "currentDSM.xyz", # hopefully saves merged cloud with a space separator as currentDSM.xyz
          "-CLEAR_CLOUDS", #closes all currently loaded clouds
          sep = " "))



#then import/call/read in the saved version of merged clouds for currentDSM as input for forestr script