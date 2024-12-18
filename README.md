# ImageResamplerTest
 
Tests multiple (13) Delphi resizing algorithms that can be found on the Internet for free to find the best one.  
The test include also some personal or 3rd party algorithms.  
If you don't have access to their source code, you will have to switch off the $3RDPARTY switch.  

Tests: 
   * Resample up  
   * Resample down  
    
Tested algorithms:
   01 JanFX SmoothResize
   02 JanFX Stretch
   03 Transform (from Graphics32)
   04 HB (Private)
   05 madGraphics (from madShi)
   07 VCL.Stretch (from Embarcadero)
   08 SmoothResize (assembler)
   09 Windows Thumbnail (Windows API)
   10 Windows StretchBlt (Windows API)
   11 FMX.CreateThumbnail (from Embarcadero)
   12 Windows.WIC (Windows API)
   13 Windows.GDI (Windows API)
    
    
Precompiled EXE file available:
![Screenshot](/About/screenshot.png)     

 ------------------------------------------------------------------------------------------------------------

Conclusions    
   Quality: Most algorithms are suitable to scale down a high res image. This is not true for scaling up. Some algorithms are much better than others.
   Speed: Here things are much different. Some algorithms could be 10x faster than others, while outpuing similar quality.   
   
   The winner is Windows.StretchBlt.  
   In all tests the Embarcadero algorithms came worst.
   

Future   
   Start this project if you want to see more almgorithms compared. 
