Strict

Public

' Imports:
Private
	'Import special.specialobject
	Import special.ssmapdata2
Public

' Classes / Interfaces:
Class SSMapData Extends SSMapData2 ' Interface
	' Constant variable(s):
	Global STAGE_1:Int[][] = [
								[0, -40, 1216, 0],
								[10, -40, 1312, 0],
								[-10, -40, 1312, 0],
								[10, -40, 1408, 0],
								[-10, -40, 1408, 0],
								[0, -40, 1472, 0],
								[10, -120, 2400, 0],
								[-10, -120, 2400, 0],
								[10, -120, 2496, 0],
								[-10, -120, 2496, 0],
								[10, -120, 2592, 0],
								[-10, -120, 2592, 0],
								[140, -20, 3328, 0],
								[160, -10, 3392, 0],
								[140, -20, 3456, 0],
								[160, -10, 3520, 0],
								[140, -20, 3584, 0],
								[160, -10, 3648, 0],
								[-140, -20, 4608, 0],
								[-160, -10, 4672, 0],
								[-140, -20, 4736, 0],
								[-160, -10, 4800, 0],
								[-140, -20, 4864, 0],
								[-160, -10, 4928, 0],
								[-160, 0, 6400, 0],
								[-160, 20, 6432, 0],
								[-160, -20, 6432, 0],
								[-160, 0, 6464, 0],
								[-140, 40, 6464, 0],
								[-140, -40, 6464, 0],
								[-160, 20, 6496, 0],
								[-160, -20, 6496, 0],
								[-140, 60, 6496, 0],
								[-140, -60, 6496, 0],
								[160, 0, 7680, 0],
								[160, 20, 7712, 0],
								[160, -20, 7712, 0],
								[160, 0, 7744, 0],
								[140, 40, 7744, 0],
								[140, -40, 7744, 0],
								[160, 20, 7776, 0],
								[160, -20, 7776, 0],
								[140, 60, 7776, 0],
								[140, -60, 7776, 0],
								[-150, 10, 9728, 0],
								[-150, -10, 9728, 0],
								[-150, 0, 9792, 0],
								[10, 120, 10496, 0],
								[-10, 120, 10496, 0],
								[0, 120, 10560, 0],
								[-150, 10, 11264, 0],
								[-150, -10, 11264, 0],
								[-150, 0, 11328, 0],
								[-110, -90, 12032, 0],
								[-90, -110, 12032, 0],
								[-100, -100, 12096, 0],
								[-80, -80, 13056, 0],
								[-80, -60, 13056, 0],
								[-60, -80, 13056, 0],
								[-60, -60, 13056, 0],
								[-80, -80, 13120, 0],
								[-80, -60, 13120, 0],
								[-60, -80, 13120, 0],
								[-60, -60, 13120, 0],
								[-80, -80, 13184, 0],
								[-80, -60, 13184, 0],
								[-60, -80, 13184, 0],
								[-60, -60, 13184, 0],
								[60, 20, 14080, 0],
								[60, 0, 14080, 0],
								[80, 20, 14080, 0],
								[80, 0, 14080, 0],
								[60, 20, 14144, 0],
								[60, 0, 14144, 0],
								[80, 20, 14144, 0],
								[80, 0, 14144, 0],
								[60, 20, 14208, 0],
								[60, 0, 14208, 0],
								[80, 20, 14208, 0],
								[80, 0, 14208, 0],
								[0, 0, 15616, 1],
								[0, 0, 16896, 10],
								[50, -50, 18432, 0],
								[30, -50, 18432, 0],
								[40, -60, 18496, 0],
								[40, -40, 18496, 0],
								[50, -50, 18560, 0],
								[30, -50, 18560, 0],
								[140, -20, 19456, 0],
								[160, -10, 19520, 0],
								[140, -20, 19584, 0],
								[160, -10, 19648, 0],
								[140, -20, 19712, 0],
								[160, -10, 19776, 0],
								[-140, -20, 20992, 0],
								[-160, -10, 21056, 0],
								[-140, -20, 21120, 0],
								[-160, -10, 21184, 0],
								[-140, -20, 21248, 0],
								[-160, -10, 21312, 0],
								[-100, 0, 22080, 0],
								[-80, 0, 22080, 0],
								[-90, 10, 22080, 0],
								[-90, -10, 22080, 0],
								[100, 0, 22080, 0],
								[80, 0, 22080, 0],
								[90, 10, 22080, 0],
								[90, -10, 22080, 0],
								[0, 0, 22272, 2],
								[-90, -130, 23168, 5],
								[-70, -110, 23232, 0],
								[-60, -100, 23296, 0],
								[-50, -90, 23360, 0],
								[-40, -80, 23424, 0],
								[-30, -70, 23488, 0],
								[-20, -60, 23552, 0],
								[-10, -50, 23616, 0],
								[0, -40, 23680, 0],
								[40, 10, 23936, 6],
								[-40, -80, 24384, 8],
								[0, -80, 26112, 0],
								[10, -80, 26176, 0],
								[-10, -80, 26176, 0],
								[0, -80, 26240, 0],
								[-100, 0, 27136, 9],
								[-60, 0, 27136, 9],
								[-80, 20, 27136, 9],
								[-80, -20, 27136, 9],
								[100, 0, 27136, 9],
								[60, 0, 27136, 9],
								[80, 20, 27136, 9],
								[80, -20, 27136, 9],
								[-20, -20, 27648, 0],
								[-20, -20, 27712, 0],
								[-20, -20, 27776, 0],
								[-20, -20, 27840, 0],
								[-20, -20, 27904, 0],
								[-20, -20, 27968, 0],
								[-20, -20, 28672, 1],
								[-120, 50, 29696, 0],
								[-120, 30, 29696, 0],
								[-65, 95, 29952, 0],
								[-65, 75, 29952, 0],
								[0, 130, 30208, 0],
								[0, 110, 30208, 0],
								[65, 95, 30464, 0],
								[65, 75, 30464, 0],
								[120, 50, 30720, 0],
								[120, 30, 30720, 0],
								[-100, 90, 31488, 0],
								[-90, 90, 31584, 0],
								[-100, 90, 31584, 0],
								[-90, 90, 31680, 0],
								[-100, 90, 31680, 0],
								[-90, 90, 31776, 0],
								[-100, 90, 31776, 0],
								[-90, 90, 31872, 0],
								[-90, 90, 32128, 7],
								[-80, 80, 32192, 0],
								[-70, 70, 32256, 0],
								[-60, 60, 32320, 0],
								[-50, 50, 32384, 0],
								[-40, 40, 32448, 0],
								[-30, 30, 32512, 0],
								[-20, 20, 32576, 0],
								[-10, 10, 32640, 0],
								[0, 0, 32672, 3],
								[10, -10, 32704, 0],
								[-10, -10, 32704, 0],
								[10, -10, 32768, 0],
								[-10, -10, 32768, 0],
								[10, -10, 32832, 0],
								[-10, -10, 32832, 0],
								[10, -10, 32896, 0],
								[-10, -10, 32896, 0],
								[10, -10, 32960, 0],
								[-10, -10, 32960, 0],
								[0, 0, 32960, 3],
								[0, 0, 33792, 11]]

	Global STAGE_2:Int[][] = [
								[10, 120, 2144, 0],
								[-10, 120, 2144, 0],
								[10, 120, 2240, 0],
								[-10, 120, 2240, 0],
								[10, 120, 2336, 0],
								[-10, 120, 2336, 0],
								[0, -40, 3328, 0],
								[10, -40, 3392, 0],
								[-10, -40, 3456, 0],
								[10, -40, 3520, 0],
								[-10, -40, 3584, 0],
								[0, -40, 3648, 0],
								[-120, 0, 4160, 9],
								[-40, 0, 4160, 9],
								[40, 0, 4160, 9],
								[120, 0, 4160, 9],
								[-10, 120, 5536, 0],
								[10, 120, 5568, 0],
								[-10, 120, 5600, 0],
								[10, 120, 5632, 0],
								[-10, 120, 5664, 0],
								[10, 120, 5696, 0],
								[-10, 120, 5728, 0],
								[10, 120, 5760, 0],
								[0, -120, 6272, 9],
								[0, -80, 6272, 9],
								[0, -40, 6272, 9],
								[0, 40, 6272, 9],
								[0, 80, 6272, 9],
								[0, 120, 6272, 9],
								[160, 0, 6912, 0],
								[160, 20, 6944, 0],
								[160, -20, 6944, 0],
								[160, 0, 6976, 0],
								[140, 40, 6976, 0],
								[140, -40, 6976, 0],
								[160, 20, 7008, 0],
								[160, -20, 7008, 0],
								[140, 60, 7008, 0],
								[140, -60, 7008, 0],
								[-40, 20, 7520, 0],
								[-40, 0, 7520, 0],
								[-20, 20, 7520, 0],
								[-20, 0, 7520, 0],
								[-40, 20, 7584, 0],
								[-40, 0, 7584, 0],
								[-20, 20, 7584, 0],
								[-20, 0, 7584, 0],
								[-40, 20, 7648, 0],
								[-40, 0, 7648, 0],
								[-20, 20, 7648, 0],
								[-20, 0, 7648, 0],
								[-40, 20, 7712, 0],
								[-40, 0, 7712, 0],
								[-20, 20, 7712, 0],
								[-20, 0, 7712, 0],
								[-120, 50, 8448, 0],
								[-120, 30, 8448, 0],
								[-95, 75, 8576, 0],
								[-95, 55, 8576, 0],
								[-65, 95, 8704, 0],
								[-65, 75, 8704, 0],
								[-30, 110, 8832, 0],
								[-30, 90, 8832, 0],
								[0, 130, 8960, 0],
								[0, 110, 8960, 0],
								[30, 110, 9088, 0],
								[30, 90, 9088, 0],
								[65, 95, 9216, 0],
								[65, 75, 9216, 0],
								[95, 75, 9344, 0],
								[95, 55, 9344, 0],
								[120, 50, 9472, 0],
								[120, 30, 9472, 0],
								[-120, 0, 9984, 9],
								[-40, 0, 9984, 9],
								[40, 0, 9984, 9],
								[120, 0, 9984, 9],
								[-10, -120, 9984, 0],
								[10, -120, 10016, 0],
								[-10, -120, 10048, 0],
								[10, -120, 10080, 0],
								[-10, -120, 10112, 0],
								[10, -120, 10144, 0],
								[-10, -120, 10176, 0],
								[10, -120, 10208, 0],
								[0, 0, 11424, 1],
								[10, 120, 12544, 0],
								[-10, 120, 12544, 0],
								[0, 120, 12608, 0],
								[-60, 40, 13568, 0],
								[-40, 60, 13568, 0],
								[-50, 50, 13632, 0],
								[110, 90, 14592, 0],
								[90, 110, 14592, 0],
								[100, 100, 14656, 0],
								[25, 25, 15424, 9],
								[-25, 25, 15424, 9],
								[25, -25, 15424, 9],
								[-25, -25, 15424, 9],
								[0, 0, 15456, 0],
								[0, 0, 15488, 0],
								[0, 0, 15520, 0],
								[0, 0, 15552, 0],
								[0, 0, 15584, 0],
								[0, 0, 15616, 0],
								[0, 0, 15648, 0],
								[0, 0, 15680, 0],
								[0, 0, 16896, 10],
								[-50, -50, 17920, 0],
								[-30, -50, 17920, 0],
								[-40, -60, 17984, 0],
								[-40, -40, 17984, 0],
								[-50, -50, 18048, 0],
								[-30, -50, 18048, 0],
								[140, 0, 18688, 0],
								[160, 10, 18752, 0],
								[140, -10, 18816, 0],
								[160, 10, 18880, 0],
								[140, -10, 18944, 0],
								[160, 0, 19008, 0],
								[150, 0, 19584, 9],
								[150, 10, 19648, 9],
								[150, -10, 19648, 9],
								[150, 0, 19712, 9],
								[0, -100, 20160, 0],
								[10, -100, 20256, 0],
								[-10, -100, 20256, 0],
								[10, -100, 20352, 0],
								[-10, -100, 20352, 0],
								[10, -100, 20448, 0],
								[-10, -100, 20448, 0],
								[0, -100, 20544, 0],
								[0, -100, 20800, 9],
								[10, -100, 20864, 9],
								[-10, -100, 20864, 9],
								[0, -100, 20928, 9],
								[50, 50, 21504, 0],
								[30, 50, 21600, 0],
								[40, 60, 21600, 0],
								[40, 40, 21696, 0],
								[50, 50, 21696, 0],
								[30, 50, 21792, 0],
								[-100, -100, 22304, 9],
								[-75, -75, 22304, 9],
								[-50, -50, 22304, 9],
								[-25, -25, 22304, 9],
								[25, 25, 22304, 9],
								[50, 50, 22304, 9],
								[75, 75, 22304, 9],
								[100, 100, 22304, 9],
								[120, -50, 22784, 0],
								[120, -30, 22784, 0],
								[95, -75, 22912, 0],
								[95, -55, 22912, 0],
								[65, -95, 23040, 0],
								[65, -75, 23040, 0],
								[30, -110, 23168, 0],
								[30, -90, 23168, 0],
								[0, -130, 23296, 0],
								[0, -110, 23296, 0],
								[-30, -110, 23424, 0],
								[-30, -90, 23424, 0],
								[-65, -95, 23552, 0],
								[-65, -75, 23552, 0],
								[-95, -75, 23680, 0],
								[-95, -55, 23680, 0],
								[-120, -50, 23808, 0],
								[-120, -30, 23808, 0],
								[-120, 0, 23936, 5],
								[-100, 20, 24064, 0],
								[-90, 30, 24128, 0],
								[-80, 40, 24192, 0],
								[-70, 50, 24256, 0],
								[-60, 60, 24320, 0],
								[-50, 70, 24384, 0],
								[-40, 80, 24448, 0],
								[-30, 90, 24512, 0],
								[0, 0, 25856, 1],
								[0, -120, 26880, 9],
								[0, -80, 26880, 9],
								[0, -40, 26880, 9],
								[80, 80, 26880, 0],
								[90, 70, 26976, 0],
								[70, 90, 26976, 0],
								[80, 80, 27072, 0],
								[-100, 100, 27392, 9],
								[-75, 75, 27392, 9],
								[-50, 50, 27392, 9],
								[-25, 25, 27392, 9],
								[0, 120, 27392, 0],
								[10, 120, 27488, 0],
								[-10, 120, 27488, 0],
								[0, 120, 27584, 0],
								[-120, 0, 27904, 9],
								[-80, 0, 27904, 9],
								[-40, 0, 27904, 9],
								[-80, 80, 27904, 0],
								[-90, 70, 28000, 0],
								[-70, 90, 28000, 0],
								[-80, 80, 28096, 0],
								[0, 0, 28416, 8],
								[-100, -100, 28416, 9],
								[-75, -75, 28416, 9],
								[-50, -50, 28416, 9],
								[-25, -25, 28416, 9],
								[-140, 0, 29184, 0],
								[-140, 10, 29280, 0],
								[-140, -10, 29280, 0],
								[-140, 10, 29376, 0],
								[-140, -10, 29376, 0],
								[-140, 0, 29472, 0],
								[-10, 120, 29984, 0],
								[10, 120, 30048, 0],
								[-10, 120, 30112, 0],
								[10, 120, 30144, 0],
								[-10, 120, 30176, 0],
								[10, 120, 30208, 0],
								[-10, 120, 30240, 0],
								[10, 120, 30272, 0],
								[140, 0, 31488, 0],
								[160, 10, 31552, 0],
								[140, -10, 31616, 0],
								[160, 10, 31680, 0],
								[140, -10, 31744, 0],
								[160, 0, 31808, 0],
								[20, 20, 32512, 9],
								[-20, 20, 32512, 9],
								[20, -20, 32512, 9],
								[-20, -20, 32512, 9],
								[10, -10, 32768, 0],
								[10, 10, 32768, 0],
								[-10, -10, 32768, 0],
								[-10, 10, 32768, 0],
								[10, -10, 32832, 0],
								[10, 10, 32832, 0],
								[-10, -10, 32832, 0],
								[-10, 10, 32832, 0],
								[10, -10, 32896, 0],
								[10, 10, 32896, 0],
								[-10, -10, 32896, 0],
								[-10, 10, 32896, 0],
								[0, 0, 33216, 3],
								[0, 0, 33792, 11]]
	
	
	Global STAGE_3:Int[][] = [
								[0, -120, 1216, 0],
								[10, -120, 1312, 0],
								[-10, -120, 1312, 0],
								[10, -120, 1408, 0],
								[-10, -120, 1408, 0],
								[10, -120, 1472, 0],
								[-10, -120, 1472, 0],
								[0, -120, 1568, 0],
								[100, 40, 2240, 0],
								[110, 40, 2336, 0],
								[90, 40, 2336, 0],
								[110, 40, 2432, 0],
								[90, 40, 2432, 0],
								[100, 40, 2528, 0],
								[100, 40, 2864, 9],
								[110, 40, 2928, 9],
								[90, 40, 2928, 9],
								[100, 40, 2992, 9],
								[100, 40, 3328, 0],
								[110, 40, 3424, 0],
								[90, 40, 3424, 0],
								[110, 40, 3520, 0],
								[90, 40, 3520, 0],
								[100, 40, 3616, 0],
								[-10, -120, 4432, 0],
								[10, -120, 4464, 0],
								[-10, -120, 4496, 0],
								[10, -120, 4528, 0],
								[-10, -120, 4560, 0],
								[10, -120, 4592, 0],
								[-10, -120, 4624, 0],
								[10, -120, 4656, 0],
								[0, -120, 4992, 9],
								[10, -120, 5056, 9],
								[-10, -120, 5056, 9],
								[0, -120, 5120, 9],
								[-120, -80, 5888, 0],
								[-90, -80, 5952, 0],
								[-60, -80, 6016, 0],
								[-30, -80, 6080, 0],
								[0, -80, 6144, 0],
								[30, -80, 6208, 0],
								[60, -80, 6272, 0],
								[90, -80, 6336, 0],
								[120, -80, 6400, 0],
								[100, -100, 7168, 9],
								[75, -75, 7168, 9],
								[50, -50, 7168, 9],
								[25, -25, 7168, 9],
								[-25, 25, 7168, 9],
								[-50, 50, 7168, 9],
								[-75, 75, 7168, 9],
								[-100, 100, 7168, 9],
								[100, 100, 7168, 9],
								[75, 75, 7168, 9],
								[50, 50, 7168, 9],
								[25, 25, 7168, 9],
								[-25, -25, 7168, 9],
								[-50, -50, 7168, 9],
								[-75, -75, 7168, 9],
								[-100, -100, 7168, 9],
								[-120, -120, 7936, 5],
								[-100, -100, 8064, 0],
								[-80, -80, 8192, 0],
								[-60, -60, 8320, 0],
								[-40, -40, 8448, 0],
								[-20, -20, 8576, 0],
								[0, 100, 8960, 9],
								[0, -100, 8960, 9],
								[100, 0, 8960, 9],
								[-100, 0, 8960, 9],
								[71, 71, 8960, 9],
								[71, -71, 8960, 9],
								[-71, 71, 8960, 9],
								[-71, -71, 8960, 9],
								[0, 0, 8960, 4],
								[-20, 20, 9088, 0],
								[-40, 40, 9216, 0],
								[-60, 60, 9344, 0],
								[-80, 80, 9472, 0],
								[-100, 100, 9600, 0],
								[-120, 120, 9984, 3],
								[-120, 120, 10112, 0],
								[-120, 120, 10240, 0],
								[-120, 120, 10368, 0],
								[-120, 120, 10496, 0],
								[-120, 120, 10624, 0],
								[-120, 120, 11264, 9],
								[-140, 100, 11328, 9],
								[-100, 140, 11328, 9],
								[-120, 120, 11392, 9],
								[100, 100, 12160, 0],
								[110, 90, 12224, 0],
								[90, 110, 12224, 0],
								[100, 100, 12288, 0],
								[-100, 100, 13040, 0],
								[-110, 90, 13104, 0],
								[-90, 110, 13104, 0],
								[-100, 100, 13168, 0],
								[0, 0, 13824, 1],
								[90, 90, 14848, 0],
								[100, 80, 14944, 0],
								[80, 100, 14944, 0],
								[100, 80, 15008, 0],
								[80, 100, 15008, 0],
								[100, 80, 15104, 0],
								[80, 100, 15104, 0],
								[90, 90, 15200, 0],
								[90, 90, 15536, 9],
								[100, 80, 15600, 9],
								[80, 100, 15600, 9],
								[90, 90, 15664, 9],
								[0, -120, 16176, 0],
								[10, -120, 16272, 0],
								[-10, -120, 16272, 0],
								[10, -120, 16368, 0],
								[-10, -120, 16368, 0],
								[10, -120, 16464, 0],
								[-10, -120, 16464, 0],
								[0, -120, 16560, 0],
								[0, -120, 16640, 4],
								[-20, -100, 16768, 0],
								[-30, -90, 16832, 0],
								[-40, -80, 16896, 0],
								[-50, -70, 16960, 0],
								[-60, -60, 17024, 5],
								[-40, -40, 17152, 0],
								[-30, -30, 17216, 0],
								[-20, -20, 17280, 0],
								[-10, -10, 17344, 0],
								[0, 0, 17408, 3],
								[0, 0, 19200, 10],
								[70, -70, 20992, 0],
								[50, -70, 20992, 0],
								[60, -80, 21056, 0],
								[60, -60, 21056, 0],
								[70, -70, 21120, 0],
								[50, -70, 21120, 0],
								[60, -70, 21712, 9],
								[70, -60, 21776, 9],
								[50, -80, 21776, 9],
								[60, -70, 21840, 9],
								[-120, 50, 22272, 0],
								[-120, 30, 22272, 0],
								[-95, 75, 22400, 0],
								[-95, 55, 22400, 0],
								[-65, 95, 22528, 0],
								[-65, 75, 22528, 0],
								[-30, 110, 22656, 0],
								[-30, 90, 22656, 0],
								[0, 130, 22784, 0],
								[0, 110, 22784, 0],
								[30, 110, 22912, 0],
								[30, 90, 22912, 0],
								[65, 95, 23040, 0],
								[65, 75, 23040, 0],
								[95, 75, 23168, 0],
								[95, 55, 23168, 0],
								[120, 50, 23296, 0],
								[120, 30, 23296, 0],
								[120, -50, 23424, 0],
								[120, -30, 23424, 0],
								[95, -75, 23552, 0],
								[95, -55, 23552, 0],
								[65, -95, 23680, 0],
								[65, -75, 23680, 0],
								[30, -110, 23808, 0],
								[30, -90, 23808, 0],
								[0, -130, 23936, 0],
								[0, -110, 23936, 0],
								[-30, -110, 24064, 0],
								[-30, -90, 24064, 0],
								[-65, -95, 24192, 0],
								[-65, -75, 24192, 0],
								[-95, -75, 24320, 0],
								[-95, -55, 24320, 0],
								[-120, -50, 24448, 0],
								[-120, -30, 24448, 0],
								[-120, 0, 24704, 9],
								[-120, 10, 24768, 9],
								[-120, -10, 24832, 9],
								[-120, 0, 24896, 9],
								[100, -100, 26112, 0],
								[75, -75, 26112, 0],
								[50, -50, 26112, 0],
								[25, -25, 26112, 0],
								[-25, 25, 26112, 9],
								[-50, 50, 26112, 9],
								[-75, 75, 26112, 9],
								[-100, 100, 26112, 9],
								[100, 100, 26112, 9],
								[75, 75, 26112, 9],
								[50, 50, 26112, 9],
								[25, 25, 26112, 9],
								[-25, -25, 26112, 9],
								[-50, -50, 26112, 9],
								[-75, -75, 26112, 9],
								[-100, -100, 26112, 9],
								[0, 80, 26880, 0],
								[10, 80, 26944, 0],
								[-10, 80, 26944, 0],
								[10, 80, 27008, 0],
								[-10, 80, 27008, 0],
								[0, 80, 27072, 0],
								[0, -80, 27392, 0],
								[10, -80, 27456, 0],
								[-10, -80, 27456, 0],
								[10, -80, 27520, 0],
								[-10, -80, 27520, 0],
								[0, -80, 27584, 0],
								[-120, 80, 28160, 0],
								[-90, 80, 28224, 0],
								[-60, 80, 28288, 0],
								[-30, 80, 28352, 0],
								[0, 80, 28416, 0],
								[30, 80, 28480, 0],
								[60, 80, 28544, 0],
								[90, 80, 28608, 0],
								[120, 80, 28672, 0],
								[-90, -90, 29248, 0],
								[-100, -80, 29344, 0],
								[-80, -100, 29344, 0],
								[-100, -80, 29440, 0],
								[-80, -100, 29440, 0],
								[-90, -90, 29536, 0],
								[0, 0, 30208, 1],
								[0, -120, 31488, 0],
								[10, -120, 31584, 0],
								[-10, -120, 31584, 0],
								[10, -120, 31680, 0],
								[-10, -120, 31680, 0],
								[0, -120, 31776, 0],
								[100, 100, 32512, 0],
								[80, 120, 32608, 0],
								[120, 80, 32608, 0],
								[80, 120, 32704, 0],
								[120, 80, 32704, 0],
								[100, 100, 32800, 0],
								[100, 100, 32896, 6],
								[80, 80, 33024, 0],
								[60, 60, 33152, 0],
								[40, 40, 33280, 0],
								[20, 20, 33408, 0],
								[0, 0, 33536, 7],
								[20, -20, 33664, 0],
								[40, -40, 33792, 0],
								[60, -60, 33920, 0],
								[80, -80, 34048, 0],
								[120, -120, 34176, 0],
								[120, -120, 34304, 4],
								[60, -60, 34688, 8],
								[0, 0, 35328, 3],
								[0, 0, 36352, 11]]
	
	Global STAGE_4:Int[][] = [[]] ' Const
	Global STAGE_LIST:Int[][][] = [STAGE_1, STAGE_2, STAGE_3, STAGE_4, STAGE_5, STAGE_6, STAGE_7] ' Const
End