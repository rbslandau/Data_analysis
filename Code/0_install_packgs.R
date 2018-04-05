pkgs <- readLines(file("https://raw.githubusercontent.com/rbslandau/data_analysis/master/Data/installed_pkgs.txt", "r"))
str(pkgs)
install.packages(pkgs)
