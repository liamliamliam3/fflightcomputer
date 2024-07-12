This is a barebones CLI flight computer written in FORTRAN. It has many handy functions that are helpful when flying around in Xplane or MSFS. 

The features that are working well currently are:
  A three degree slope calculator
  A descent initation calculator
  MPH to KNT Unit conversion
  A fuel burnrate calculator
  An ETA and expected fuel burn calculator
  A distance from point calcualtor
  A METAR and TAF fetcher using the NWS API

  I am working on a calcuator that takes a set of coordinates and based on your current coordinates returns a bearing and appromixate distance.

Only dependency besides a FORTRAN compiler is CURL. It is used soley to fetch the weather data from the National Weather Service API.

I use gfortran as my compiler. I attached the little script I use to compile and test. It has been tested on macOS and Linux but I have not given it a try on Windows yet. Ideally you should be able to bust out any old computer capable of running FORTRAN (and CURL if you use the weather API) and use it as your flight computer.

This is a learning project for me. I am new to programming and I like making little utitlities like this. Expect it to be VERY VERY rough currently. This is not a finished product by anymeans but it still could be useful in its curent state.
