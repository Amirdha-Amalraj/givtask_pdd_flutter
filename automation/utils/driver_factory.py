from appium import webdriver
from appium.options.android import UiAutomator2Options
from config.capabilities import get_android_capabilities

class DriverFactory:
    @staticmethod
    def get_driver():
        caps = get_android_capabilities()
        options = UiAutomator2Options().load_capabilities(caps)
        # Default local appium server
        driver = webdriver.Remote("http://127.0.0.1:4723", options=options)
        driver.implicitly_wait(10)
        return driver
