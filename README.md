This is a barebones CLI flight computer written in FORTRAN. It has many handy functions that are helpful when flying around in Xplane or MSFS. 

<img width="844" alt="Screenshot 2024-07-11 at 9 57 31 PM" src="https://github.com/user-attachments/assets/b0e2dc62-8c5b-4149-863b-deb2857e02ae">

The features that are working well currently are:
  A three degree slope calculator
  A descent initation calculator
  MPH to KNT Unit conversion
  A fuel burnrate calculator
  An ETA and expected fuel burn calculator
  A distance from point calcualtor
  A METAR and TAF fetcher using the NWS API

<img width="850" alt="Screenshot 2024-07-11 at 10 01 55 PM" src="https://github.com/user-attachments/assets/7fd07fec-2092-4b52-80c7-02097853771e">

  I am working on a calcuator that takes a set of coordinates and based on your current coordinates returns a bearing and appromixate distance.

Only dependency besides a FORTRAN compiler is CURL. It is used soley to fetch the weather data from the National Weather Service API.

<img width="841" alt="Screenshot 2024-07-11 at 9 58 21 PM" src="https://github.com/user-attachments/assets/2e6db2b2-c12b-4ca6-94a0-bb16aff3f453">

I use gfortran as my compiler. I attached the little script I use to compile and test. It has been tested on macOS and Linux but I have not given it a try on Windows yet. Ideally you should be able to bust out any old computer capable of running FORTRAN (and CURL if you use the weather API) and use it as your flight computer.

This is a learning project for me. I am new to programming and I like making little utitlities like this. Expect it to be VERY VERY rough currently. This is not a finished product by anymeans but it still could be useful in its curent state.
