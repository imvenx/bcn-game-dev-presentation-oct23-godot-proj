extends WorldEnvironment

var padQuaternion = Quat()
onready var meshChild = get_child(0)

func _ready():
#	var initParams = { 'arcaneCode': '0.30' }
	Arcane.init()
	Arcane.signals.connect("ArcaneClientInitialized", self, "onArcaneClientInitialized")

	yield(get_tree().create_timer(4.0), "timeout")
	$CSGMesh/Phone.hide()

func onArcaneClientInitialized(_e):
	if not Arcane.pads: return
	var pad = Arcane.pads[0]
	initController(pad)
	
	
func initController(pad):
	pad.startGetQuaternion()
	pad.connect('GetQuaternion', self, 'onGetQuaternion')
	pad.connect('IframePadConnect', self, 'onPadConnect')


func onPadConnect(e):
	for pad in Arcane.pads:
		if(pad.deviceId == e.deviceId):
			initController(pad)
			return


func onGetQuaternion(e):
	padQuaternion.x = -e.x
	padQuaternion.y = -e.y
	padQuaternion.z = e.z
	padQuaternion.w = e.w


func _process(_delta):
	meshChild.transform.basis = Basis(padQuaternion)
