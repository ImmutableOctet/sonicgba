' Preprocessor related:
#MONKEYLANG_EXTENSION_WIDECHARACTERS = True

#GLFW_USE_MINGW = False

'#SONICGBA_EASTEREGGS = True

' Debugging related:

' This enables the user to have an abnormal number of lives.
#SONICGBA_FORCE_MAX_LIVES = True

' This enables a higher internal resolution. (Unfinished behavior)
#SONICGBA_RESOLUTION_TEST = True

' This disables scheduled room updates.
'#SONICGBA_DISABLE_ROOM_UPDATES = True ' False

'#SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_INDICES = True

#SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_EXCEPTIONS = True

#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_INDICES
	'#SONICGBA_GAMEOBJECT_ANNOUNCE_LOADED_INFO = True
#End

#SONICGBA_MFGAMEPAD_AUTOJUMP = True

#IOUTIL_PUBLICDATASTREAM_LEGACY_BIG_ENDIAN = False
#IOUTIL_ENDIANSTREAM_LEGACY_BIG_ENDIAN = False

#If TARGET = "glfw" Or TARGET = "stdcpp"
	#SONICGBA_FILESYSTEM_ENABLED = True
#End

#MOJO_IMAGE_FILTERING_ENABLED = False ' True

'#If TARGET <> "html5"
#MOJO_AUTO_SUSPEND_ENABLED = False
'#End

' File formats:
#TEXT_FILES+="*.txt|*.xml|*.json|*.ssm|*.glsl"
#IMAGE_FILES+="*.png|*.jpg"
#SOUND_FILES+="*.wav|*.ogg"
#MUSIC_FILES+="*.wav|*.ogg"
#BINARY_FILES+="*.bin|*.dat|*.ci|*.co|*.en|*.gi|*.it|*.pal|*.pm|*.pyx|*.ri"

' GLFW Configuration:
#GLFW_WINDOW_TITLE = "Sonic Advance"
#GLFW_WINDOW_WIDTH = 1280 ' 360
#GLFW_WINDOW_HEIGHT = 720 ' 640
#GLFW_WINDOW_SAMPLES = 0
#GLFW_WINDOW_RESIZABLE = True
#GLFW_WINDOW_DECORATED = True
#GLFW_WINDOW_FLOATING = False
#GLFW_WINDOW_FULLSCREEN = False