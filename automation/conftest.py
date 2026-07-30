import pytest
import os
from datetime import datetime
from utils.driver_factory import DriverFactory

@pytest.fixture(scope="function")
def driver(request):
    driver_instance = DriverFactory.get_driver()
    request.cls.driver = driver_instance
    yield driver_instance
    driver_instance.quit()

@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    # execute all other hooks to obtain the report object
    outcome = yield
    rep = outcome.get_result()
    
    # We only look at actual failing test calls, not setup/teardown
    if rep.when == 'call' and rep.failed:
        # Check if the fixture has injected a driver
        if hasattr(item.instance, 'driver'):
            driver = item.instance.driver
            screenshot_dir = os.path.join(os.path.dirname(__file__), "screenshots")
            os.makedirs(screenshot_dir, exist_ok=True)
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            screenshot_name = f"{item.name}_{timestamp}.png"
            screenshot_path = os.path.join(screenshot_dir, screenshot_name)
            driver.save_screenshot(screenshot_path)
            
            # Attach to HTML report
            if 'html' in item.config.pluginmanager.list_name_plugin():
                from pytest_html import extras
                html_extra = extras.image(screenshot_path)
                if not hasattr(rep, "extra"):
                    rep.extra = []
                rep.extra.append(html_extra)
