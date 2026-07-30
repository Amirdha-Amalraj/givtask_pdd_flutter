from appium.webdriver.common.appiumby import AppiumBy
from pages.base_page import BasePage

class LandingPage(BasePage):
    # REPLACE WITH ACTUAL ACCESSIBILITY IDS USING APPIUM INSPECTOR
    LOGIN_BUTTON = (AppiumBy.ACCESSIBILITY_ID, "Landing_Login_Button")
    REGISTER_BUTTON = (AppiumBy.ACCESSIBILITY_ID, "Landing_Register_Button")
    LOGO = (AppiumBy.ACCESSIBILITY_ID, "GivTask_Logo")

    def click_login(self):
        self.click(self.LOGIN_BUTTON)

    def click_register(self):
        self.click(self.REGISTER_BUTTON)

    def is_logo_visible(self):
        return self.is_displayed(self.LOGO)
