Strict

Public

' Preprocessor related:
#If CONFIG = "debug"
	#SONICGBA_DEBUG_MFIMAGE = True
#End

#If SONICGBA_DEBUG_MFIMAGE Or TARGET = "html5"
	#SONICGBA_MFIMAGE_STOP_ON_NULL = True
#End

' Friends:
Friend com.sega.mobile.framework.device.mfgraphics

' Imports:
Private
	Import brl.databuffer
	Import brl.stream
	Import brl.datastream
	Import brl.filepath
	
	Import opengl.gles20
	
	Import mojo2.graphics
	
	Import regal.png
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfdevice
Public

' Classes:
Class MFImage
	Private
		' Fields:
		Field alphaColor:Int
		Field graphics:MFGraphics
		
		Field mutable:Bool
	Protected
		' Fields:
		Field image:Image
		
		' Methods:
		' Nothing so far.
	Private
		' Functions:
		
		' Extensions:
		
		' These generate native image handles:
		Function generateImage:Image(width:Int, height:Int, flags:Int=Image.Managed) ' Image.Mipmap
			Return New Image(width, height, 0.0, 0.0, flags) ' Image.Managed
		End
		
		Function generateImage:Image(path:String, flags:Int=Image.Mipmap)
			Local img:= Image.Load(MFDevice.FixGlobalPath(path), 0.0, 0.0, flags)
			
			#If SONICGBA_MFIMAGE_STOP_ON_NULL
				If (img = Null) Then
					DebugStop()
				EndIf
			#End
			
			Return img
		End
		
		' Constructor(s):
		Method New(mutable:Bool=False, alphaColor:Int=-1)
			Self.alphaColor = alphaColor
			Self.mutable = mutable
		End
	Public
		' Functions:
		
		' Extensions:
		Function releaseImage:Bool(img:MFImage)
			If (img <> Null) Then
				img.discard()
				
				Return True
			EndIf
			
			Return False
		End
		
		Function cloneImage:MFImage(img:MFImage)
			If (img = Null) Then
				' Throw New ImageNotClonedExeception(...)
				
				Return Null
			EndIf
			
			Return createImage(img, 0, 0, img.getWidth(), img.getHeight())
		End
		
		' These functions may be replaced at a later date:
		Function generateNativeImage:Image(width:Int, height:Int)
			Return generateImage(width, height)
		End
		
		Function generateNativeImage:Image(path:String)
			Return generateImage(path)
		End
		
		Function readByteSafely:Int(is:Stream) ' Byte
			If (is.Eof()) Then
				Return 0
			EndIf
			
			Return is.ReadByte()
		End
		
		Function readRGBColor:Int(is:Stream, a:Int=255) ' 0
			Local r:= 0
			Local g:= 0
			Local b:= 0
			
			r = readByteSafely(is)
			g = readByteSafely(is)
			b = readByteSafely(is)
			
			' Read red, green, and blue values from the input-stream.
			Return MFGraphics.valuesToColor(r, g, b, a)
		End
		
		' I/O routines:
		Function seekForward:Int(is:Stream, forward_bytes:Int)
			Local new_position:= (is.Position() + forward_bytes)
			
			is.Seek(new_position)
			
			Return new_position
		End
		
		' These functions read a PLTE chunks from PNG files, then output a color-table.
		' Each color channel is 8-bit, encoded using 'MFGraphics':
		
		' This implementation expects the first four bytes to be the PLTE tag.
		Function readPalette:Int[](is:Stream) ' Stack<Int> ' length:Int
			Local x:= is.Position
			
			seekForward(is, 4) ' PLTE
			
			Local remainingBytes:= (is.Length - is.Position)
			Local palette:= New Int[(remainingBytes / 3)]
			
			PNG.ReadPaletteData(is, palette, palette.Length)
			
			Return palette
		End
		
		' This returns the index at which 'pixel' was found.
		' If nothing was found, this will return -1.
		Function getPaletteEntry:Int(palette:Int[], pixel:Int)
			For Local I:= 0 Until palette.Length
				If (palette[I] = pixel) Then
					Return I
				EndIf
			Next
			
			Return -1
		End
		
		' This loads a palette descriptor file.
		' These files describe a local image name,
		' and a set of bytes to patch it with.
		Function createPaletteImage:MFImage(paletteFileName:String) ' Final
			Local is:Stream
			
			Try
				Local data:Int
				
				is = MFDevice.getResourceAsStream(paletteFileName)
				
				Local imageName:= is.ReadString(is.ReadByte(), "ascii")
				
				Local customPalette:= readPalette(is)
				
				is.Close()
				
				Local pixMapPath:= (ExtractDir(paletteFileName) + "/" + imageName)
				
				is = MFDevice.getResourceAsStream(pixMapPath)
				
				Local state:= New PNGDecodeState()
				
				' Manually assign a custom color-palette.
				state.Palette = customPalette
				
				' Begin loading from the PNG data-stream.
				Local png:= New PNG(is)
				
				While (Not is.Eof())
					If (Not png.Decode(is, state, True, True)) Then
						Exit
					Endif
				Wend
				
				is.Close()
				
				Local header:= png.Header
				
				Local width:= header.width
				Local height:= header.height
				
				Local imageData:= png.ImageData
				
				Local img:= generateImage(width, height)
				
				img.WritePixels(0, 0, width, height, imageData)
				
				Return createImage(img)
			Catch E:Throwable
				If (is <> Null) Then
					is.Close()
				EndIf
				
				#If CONFIG = "debug"
					'Print(E.ToString())
				#End
			End Try
			
			Return Null
		End
		
		Function createImage:MFImage(url:String, flags:Int=Image.Mipmap) ' Final
			Return createImage(generateImage(url, flags))
		End
		
		Function createImage:MFImage(sysImg:Image, mutable:Bool=False) ' Final
			Local ret:= New MFImage(mutable)
			
			ret.image = sysImg
			
			Return ret
		End
		
		Function createImage:MFImage(instance:MFImage, x:Int, y:Int, width:Int, height:Int, __unused_transform:Int=TRANS_NONE) ' 0
			Local srcImg:= instance.image
			Local mutable:= instance.mutable
			
			Return createImage(New Image(srcImg, x, y, width, height, srcImg.HandleX, srcImg.HandleY), mutable)
		End
		
		Function createImage:MFImage(width:Int, height:Int, flags:Int=Image.Mipmap) ' Final
			Local ret:= New MFImage(True)
			
			ret.image = New Image(width, height, 0.0, 0.0, flags) ' | Image.Managed
			ret.graphics = MFGraphics.createMFGraphics(ret, width, height)
			
			Return ret
		End
		
		#Rem
			Function createImage:MFImage(is:Stream) ' Final
				If (is = Null) Then
					Return Null
				EndIf
				
				Local ret:MFImage = Null
				
				Try
					Local img:= CreateImage()
					
					ret = createImage(MFImage.generateNativeImage(is))
				Catch E:StreamError
					' Nothing so far.
				End Try
				
				is.Close()
				
				Return ret
			End
		#End
		
		#Rem
			Function createImage:MFImage(image:MFImage, x:Int, y:Int, width:Int, height:Int, transform:Int) ' Final
				Return createImage(generateImage(image.image, x, y, width, height, transform))
			End
		#End
		
		#Rem
			Function createImage:MFImage(data:DataBuffer) ' Final
				Local bais:= New EndianStreamManager<DataStream>(New DataStream(data), True) ' False
				Local ret:= createImage(bais)
				
				bais.Close()
				
				Return ret
			End
		
			Function createImage:MFImage(data:DataBuffer, offset:Int, length:Int) ' Final
				Local bais:= New EndianStreamManager<DataStream>(New DataStream(data, offset, length), True) ' False
				Local ret:= createImage(bais)
				
				bais.Close()
				
				Return ret
			End
		#End
		
		' Methods:
		
		' Extensions:
		Method discard:Void() Final
			Self.image.Discard()
			
			#If Not SONICGBA_DEBUG_MFIMAGE
				Self.image = Null
			#End
		End
		
		Method getNativeImage:Image() Final
			Return Self.image
		End
		
		Method getGraphics:MFGraphics() Final
			Return Self.graphics
		End
		
		Method getWidth:Int() Final
			Return Self.image.Width() ' Width
		End
		
		Method getHeight:Int() Final
			Return Self.image.Height() ' Height
		End
		
		' This method may be implemented at a later date.
		' To my knowledge, it's basically the same thing as Mojo's 'ReadPixels' command.
		Method getRGB:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int) Final
			'Self.image.getRGB(rgbData, offset, scanlength, x, y, width, height)
		End
		
		Method isMutable:Bool() ' Property
			Return Self.mutable
		End
		
		Method setAlphaColor:Void(color:Int)
			Self.alphaColor = (MFGraphics.COLOR_MASK_ALPHA | color)
		End
		
		Method getAlphaColor:Int()
			Return Self.alphaColor
		End
		
		Method setAlpha:Void(a:Int)
			'Self.image.setAlpha(a)
		End
	
		Method getAlpha:Int()
			'Return Self.image.getAlpha()
		End
End