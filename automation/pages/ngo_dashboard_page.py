from appium.webdriver.common.appiumby import AppiumBy
from pages.base_page import BasePage

class NGODashboardPage(BasePage):
    CREATE_TASK_FAB = (AppiumBy.ACCESSIBILITY_ID, "FAB_Create_Task")
    VOLUNTEER_DIR_TAB = (AppiumBy.ACCESSIBILITY_ID, "Tab_Volunteer_Directory")
    APPLICATIONS_TAB = (AppiumBy.ACCESSIBILITY_ID, "Tab_Applications")
    ACCEPT_BUTTON = (AppiumBy.ACCESSIBILITY_ID, "Button_Accept_Application")

    def click_create_task(self):
        self.click(self.CREATE_TASK_FAB)

    def go_to_applications(self):
        self.click(self.APPLICATIONS_TAB)
        
    def accept_first_application(self):
        self.click(self.ACCEPT_BUTTON)
