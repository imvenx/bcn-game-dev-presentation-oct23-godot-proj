extends WorldEnvironment

var padQuaternion = Quat()
onready var meshChild = get_child(0)

onready var audioPlayer:AudioStreamPlayer = $AudioPlayer
var swordSound = load("res://sounds/sword2.mp3")
var batSound = load("res://sounds/bat.mp3")
var guitarSound = load("res://sounds/guitar.mp3")
var rockMusic = load("res://sounds/rock.mp3")
var gunSound = load("res://sounds/gun.mp3")


func _ready():
#	var initParams = { 'arcaneCode': '0.30' }
	Arcane.init()
	Arcane.signals.connect("ArcaneClientInitialized", self, "onArcaneClientInitialized")

	yield(get_tree().create_timer(4.0), "timeout")
	$CSGMesh/Phone.hide()
	$CSGMesh/sword.show()
	
	yield(get_tree().create_timer(2.0), "timeout")
	playSound(swordSound)
	
	yield(get_tree().create_timer(2.0), "timeout")
	$CSGMesh/sword.hide()
	$CSGMesh/bat_joined.show()
	yield(get_tree().create_timer(2.0), "timeout")
	playSound(batSound)
	
	yield(get_tree().create_timer(2.0), "timeout")
	$CSGMesh/bat_joined.hide()
	
	
#	$VideoPlayer.show()
#	$VideoPlayer.play()
	
#	yield(get_tree().create_timer(29), "timeout")
	$CSGMesh/guitar.show()
	$BgMusic.stop()
	
	yield(get_tree().create_timer(2.0), "timeout")
	$BgMusic.stream = rockMusic
	$BgMusic.play()
	
	yield(get_tree().create_timer(14), "timeout")
	playSound(gunSound)
	
	yield(get_tree().create_timer(3), "timeout")
	$CSGMesh/guitar.hide()
	$CSGMesh/gun.show()
	

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
	

func playSound(audioStream):
	audioStream.loop = false
	audioPlayer.stream = audioStream
	audioPlayer.play()
	
