# ImageResamplerTest
 
This tool tests 13 resizing algorithms (available as Delphi code).  
    
**Tested algorithms**  
   01 JanFX SmoothResize
   02 JanFX Stretch
   03 Transform (from Graphics32)
   04 HB (Private)
   05 madGraphics (from madShi)
   06 VCL.ScaleImage (from Embarcadero)
   07 VCL.Stretch (from Embarcadero)
   08 SmoothResize (assembler)
   09 Windows Thumbnail (Windows API)
   10 Windows StretchBlt (Windows API)
   11 FMX.CreateThumbnail (from Embarcadero)
   12 Windows.WIC (Windows API)
   13 Windows.GDI (Windows API)
   
Tests: 
   * Resample up  
   * Resample down     
   
Two of the above tests include 3rd party algorithms.  
If you don't have access to their source code, you will have to switch off the {$3RDPARTY} switch.     
    
**Test program** 
Precompiled EXE file and test images (high res/low res) available:
![Screenshot](/About/screenshot.png)     

 ------------------------------------------------------------------------------------------------------------

**Conclusions**   
   Quality: Most algorithms are suitable to scale down a high-res image. This is not true for scaling up. Some algorithms are much better than others.
   Speed: Here things are much different. Some algorithms could be 10x faster than others, while still producing similar quality.   
   
   The winner is Windows.StretchBlt.  
   In all tests, the Embarcadero algorithms came out the worst.
   
**Future**    
   Star this project if you want to see more algorithms added to the comparison. 
