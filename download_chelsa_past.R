#' Download CHELSA-TraCE21k
#'
#' This function downloads CHELSA V_2.1 BIO climatic timeseries since the LGM (Karger et al., 2018) into a specified folder.
#' CHELSA-TraCE21k data provides monthly climate data for temperature and precipitation at 30 arcsec spatial resolution in 100-yeartime steps for the last 21,000 years
#' Function adapted from Simon Kapitza's chelsa_get.R https://rdrr.io/github/kapitzas/WorldClimTiles/src/R/chelsa_get.R

#' @importFrom utils download.file

#' @param target_path Download folder on local machine. Default folder "CHELSA-TraCE21k" created in the working directory.
#' @param vars Vector of character string containing the CHELSA variables names to be downloaded, 
#' can be one of: "bio" (download bio1-19), "all" (download all available variables), or a custom set . Default "bio".
#' @param yearago Vector of time periods to download (Ky BP)
#'
#' @author Gustavo A. Silva-Arias \email{gasilvaa@unal.edu.co}
#' @export
#' @examples

#' vars <- c("bio")
#' target_path <- "my_folder/CHELSA-TraCE21k"
#' yearago <- c(22, 16.8, 14.7, 14.3, 12.2, 8.4) # time periods before present (k BP)
#' chelsa_get(target_path, vars)
#'
#' @references
#' Karger, D.N., Nobis, M.P., Normand, S., Graham, C.H., Zimmermann, N. (2023) CHELSA-TraCE21k – High resolution (1 km) downscaled transient temperature and precipitation data since the Last Glacial Maximum. Climate of the Past. https://doi.org/10.5194/cp-2021-30

## load Table 4 from CHELSA-TraCE21k documentation to get varible file names. Available in:
## https://www.envidat.ch/dataset/c88baa58-dbae-452c-8c2c-343e4c9fb885/resource/613fcb27-3649-4b5f-8880-984403cccd62/download/chelsa-trace21k_technical_documentation.pdf
time_IDs <- data.frame(timeID = c(20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,
                    -1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,
                    -16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,
                    -29,-30,-31,-32,-33,-34,-35,-36,-37,-38,-39,-40,-41,
                    -42,-43,-44,-45,-46,-47,-48,-49,-50,-51,-52,-53,-54,
                    -55,-56,-57,-58,-59,-60,-61,-62,-63,-64,-65,-66,-67,
                    -68,-69,-70,-71,-72,-73,-74,-75,-76,-77,-78,-79,-80,
                    -81,-82,-83,-84,-85,-86,-87,-88,-89,-90,-91,-92,-93,
                    -94,-95,-96,-97,-98,-99,-100,-101,-102,-103,-104,-105,
                    -106,-107,-108,-109,-110,-111,-112,-113,-114,-115,-116,
                    -117,-118,-119,-120,-121,-122,-123,-124,-125,-126,-127,
                    -128,-129,-130,-131,-132,-133,-134,-135,-136,-137,-138,
                    -139,-140,-141,-142,-143,-144,-145,-146,-147,-148,-149,
                    -150,-151,-152,-153,-154,-155,-156,-157,-158,-159,-160,
                    -161,-162,-163,-164,-165,-166,-167,-168,-169,-170,-171,
                    -172,-173,-174,-175,-176,-177,-178,-179,-180,-181,-182,
                    -183,-184,-185,-186,-187,-188,-189,-190,-191,-192,-193,
                    -194,-195,-196,-197,-198,-199,-200),
                    kBP = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,
                    1.5,1.6,1.7,1.8,1.9,2,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,
                    3,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4,4.1,4.2,4.3,4.4,
                    4.5,4.6,4.7,4.8,4.9,5,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,
                    6,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,7,7.1,7.2,7.3,7.4,
                    7.5,7.6,7.7,7.8,7.9,8,8.1,8.2,8.3,8.4,8.5,8.6,8.7,8.8,8.9,
                    9,9.1,9.2,9.3,9.4,9.5,9.6,9.7,9.8,9.9,10,10.1,10.2,10.3,
                    10.4,10.5,10.6,10.7,10.8,10.9,11,11.1,11.2,11.3,11.4,11.5,
                    11.6,11.7,11.8,11.9,12,12.1,12.2,12.3,12.4,12.5,12.6,12.7,
                    12.8,12.9,13,13.1,13.2,13.3,13.4,13.5,13.6,13.7,13.8,13.9,
                    14,14.1,14.2,14.3,14.4,14.5,14.6,14.7,14.8,14.9,15,15.1,
                    15.2,15.3,15.4,15.5,15.6,15.7,15.8,15.9,16,16.1,16.2,16.3,
                    16.4,16.5,16.6,16.7,16.8,16.9,17,17.1,17.2,17.3,17.4,17.5,
                    17.6,17.7,17.8,17.9,18,18.1,18.2,18.3,18.4,18.5,18.6,18.7,
                    18.8,18.9,19,19.1,19.2,19.3,19.4,19.5,19.6,19.7,19.8,19.9,
                    20,20.1,20.2,20.3,20.4,20.5,20.6,20.7,20.8,20.9,21,21.1,
                    21.2,21.3,21.4,21.5,21.6,21.7,21.8,21.9,22))
 
download_chelsa_past = function(target_path=file.path(getwd(),"CHELSA-TraCE21k"),
                                vars="bio",
                                yearago="") {
  timeout_old <- getOption("timeout")
  options(timeout = 1000)
  
  ## variables sets
  if(vars=="bio") {
    vars=c("bio01",
           "bio02",
           "bio03",
           "bio04",
           "bio05",
           "bio06",
           "bio07",
           "bio08",
           "bio09",
           "bio10",
           "bio11",
           "bio12",
           "bio13",
           "bio14",
           "bio15",
           "bio16",
           "bio17",
           "bio18",
           "bio19")
  } else if(vars=="all") {
    vars==c("bio01",
            "bio02",
            "bio03",
            "bio04",
            "bio05",
            "bio06",
            "bio07",
            "bio08",
            "bio09",
            "bio10",
            "bio11",
            "bio12",
            "bio13",
            "bio14",
            "bio15",
            "bio16",
            "bio17",
            "bio18",
            "bio19",
            "tasmax",
            "tasmin",
            "pr",
            "scd",
            "swe",
            "dem",
            "glz",
            "tz")
  }

  for (var in vars) {
    for (time_ID in yearago) {
      ## set output folder
      outdir = paste0(target_path, "_time_", time_ID)
      if (file.exists(outdir)){
        print("Output dir found")
      } else {
        print("Output dir not found. Creating")
        dir.create(outdir)
      }
      
      time_ID = time_IDs[time_IDs$kBP == time_ID, 1]
      name <- paste(c("CHELSA_TraCE21k", var, time_ID, "V1.0.tif"), collapse = "_")
      source_url <- file.path("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/bio",
                              name)
      destination <- file.path(outdir, name)
      if (!file.exists(destination)) {
        out <- NULL
        out <- tryCatch(download.file(source_url, destination), 
                        error = function(e) {
                          return(NA)
                        })
        if (is.na(out)) {
          next
        }
      }
      else {
        message(paste0(destination, " already downloaded, skipping to next"))
      }
    }
      
  }
  options(timeout = timeout_old)
}
