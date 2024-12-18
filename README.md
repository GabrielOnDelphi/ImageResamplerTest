# ImageResamplerTest
 
This tool tests 13 resizing algorithms (available as Delphi code). 

![Screenshot](/About/screenshot.png)   
    
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
Precompiled EXE file and test images (high res/low res) available.   

 ------------------------------------------------------------------------------------------------------------

**Conclusions**   
   This article discusses the [conclusions](https://gabrielmoraru.com/say-no-to-crappy-images-in-your-delphi-programs-finding-the-best-resizing-algorithm/) of the test and shows the resulted images.
   
**Future**    
   Star this project if you want to see more algorithms added to the comparison. 
