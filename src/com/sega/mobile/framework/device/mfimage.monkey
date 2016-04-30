Strict

Public

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
		Function generateImage:Image(width:Int, height:Int)
			Return New Image(width, height, 0.0, 0.0, Image.Mipmap) ' Image.Managed
		End
		
		Function generateImage:Image(path:String)
			Return Image.Load(path, 0.0, 0.0, Image.Mipmap)
		End
		
		' Constructor(s):
		Method New()
			Self.alphaColor = -1
			Self.mutable = False
		End
	Public
		' Functions:
		
		' Extensions:
		
		' These functions may be replaced at a later date:
		Function generateNativeImage:Image(width:Int, height:Int)
			Return generateImage(width, height)
		End
		
		Function generateNativeImage:Image(path:String)
			Return generateImage(path)
		End
		
		Function createPaletteImage:MFImage(paletteFileName:String) ' Final
			Try
				Local data:Int
				
				Local is:Stream
				
				is = MFDevice.getResourceAsStream(paletteFileName)
				
				Local imageName:= is.ReadString(is.ReadByte(), "ascii")
				
				Local palData:= is.ReadAll()
				
				is.Close()
				
				Local info:= New Int[2]
				
				Local pixMap:= LoadImageData(ExtractDir(paletteFileName) + "/" + imageName, info)
				
				For Local i:= 0 Until palData.Length
					pixMap.PokeByte((i + 37), palData.PeekByte(i))
				Next
				
				Local width:= info[0]
				Local height:= info[1]
				
				Local img:= generateImage(width, height)
				
				img.WritePixels(0, 0, width, height, pixMap)
				
				Return createImage(img)
			Catch E:StreamError ' E:Throwable
				' Nothing so far.
			End Try
			
			Return Null
		End
		
		Function createImage:MFImage(url:String) ' Final
			Return createImage(generateImage(url))
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
		
		Function createImage:MFImage(sysImg:Image) ' Final
			Local ret:= New MFImage()
			
			ret.image = sysImg
			
			Return ret
		End
		
		Function createImage:MFImage(width:Int, height:Int) ' Final
			Local ret:= New MFImage()
			
			ret.image = New Image(width, height, 0.0, 0.0)
			ret.graphics = MFGraphics.createMFGraphics(ret.getGraphics().getSystemGraphics(), width, height)
			ret.mutable = True
			
			Return ret
		End
		
		#Rem
		Function createImage:MFImage(data:DataBuffer) ' Final
			Local bais:= New DataStream(data)
			Local ret:= createImage(bais)
			
			bais.Close()
			
			Return ret
		End
	
		Function createImage:MFImage(data:DataBuffer, offset:Int, length:Int) ' Final
			Local bais:= New DataStream(data, offset, length)
			Local ret:= createImage(bais)
			
			bais.Close()
			
			Return ret
		End
		#End
		
		' Methods:
		
		' Extensions:
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
		
		Method getRGB:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int) Final
			'Self.image.getRGB(rgbData, offset, scanlength, x, y, width, height)
		End
	
		Method isMutable:Bool() ' Property
			Return Self.mutable
		End
	
		Method setAlphaColor:Void(color:Int)
			Self.alphaColor = (-16777216 | color)
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