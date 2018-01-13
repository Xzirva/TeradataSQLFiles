# Steps to use toaster to make a exploratory analysis on aster database using R

# 1. install Aster ODBC Driver : 
# Launch
# libraries/AsterClients__windows_x8664.07.00.00.00-r63672/nClusterODBCInstaller_x64
# Open RStudio or launch R
# Execute install.packages(toaster)
# Try the code below (do not forget to launch VMWare and check others prerequisites)

library(toaster)
# initialize connection to Lahman baseball database in Aster 
conn = odbcDriverConnect(connection="driver={Aster ODBC Driver};
                         server=192.168.100.220;port=2406;database=beehive;
                         uid=beehive;pwd=beehive")

# Loading videos' dimension
df_videos = computeSample(conn, 
                     "prdwa17_target.t_video", 
                     sampleFraction=1)

# Loading videos' facts
df_videofacts = computeSample(conn, 
                          "prdwa17_target.t_videofacts", 
                          sampleFraction=1)

# Loading time dimension
df_time = computeSample(conn, 
                          "prdwa17_target.t_time", 
                          sampleFraction=1)

# Loading comments' facts
df_comment_facts = computeSample(conn, 
                                 "prdwa17_target.t_videocomment", 
                                 sampleFraction=1)
