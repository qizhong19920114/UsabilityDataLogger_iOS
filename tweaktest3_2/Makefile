include theos/makefiles/common.mk

TWEAK_NAME = tweaktest3
tweaktest3_FILES = Tweak.xm
tweaktest3_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"


