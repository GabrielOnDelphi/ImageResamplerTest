# ImageResamplerTest

   Description  
     Tests multiple (13) Delphi resizing algorithms that can be found on the Internet for free to find the best one.  
     The test include also some personal or 3rd party algorithms.  
     If you don't have access to their source code, you will have to switch off the $3RDPARTY switch.  

   Tests: resamples up and down.  

 ------------------------------------------------------------------------------------------------------------

   Conclusions    
     In general, all tested algorithms seem suitable to resize down a high res image but some are faster than others.  
     The winner is Windows.StretchBlt.  
