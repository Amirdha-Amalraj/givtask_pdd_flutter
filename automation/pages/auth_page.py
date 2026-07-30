from appium.webdriver.common.appiumby import AppiumBy
from pages.base_page import BasePage

class AuthPage(BasePage):
    EMAIL_INPUT = (AppiumBy.ACCESSIBILITY_ID, "Email_Input")
    PASSWORD_INPUT = (AppiumBy.ACCESSIBILITY_ID, "Password_Input")
    LOGIN_SUBMIT = (AppiumBy.ACCESSIBILITY_ID, "Submit_Login")
    ERROR_MESSAGE = (AppiumBy.ACCESSIBILITY_ID, "Error_Message_Text")

    def login(self, email, password):
        self.type(self.EMAIL_INPUT, email)
        self.type(self.PASSWORD_INPUT, password)
        self.click(self.LOGIN_SUBMIT)

    def get_error_message(self):
        return self.get_text(self.ERROR_MESSAGE)
