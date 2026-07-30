import os

def get_android_capabilities():
    return {
        "platformName": "Android",
        "automationName": "UiAutomator2",
        # Let Appium automatically detect the connected ADB device
        # "udid": "emulator-5554", 
        "app": os.path.abspath(os.path.join(os.path.dirname(__file__), "../../build/app/outputs/flutter-apk/app-release.apk")),
        "autoGrantPermissions": True,
        "noReset": False,
        "newCommandTimeout": 300
    }
