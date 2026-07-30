import pytest
from pages.ngo_dashboard_page import NGODashboardPage

def test_create_task(driver):
    ngo_page = NGODashboardPage(driver)
    ngo_page.click_create_task()
    # Populate fields and save...

def test_accept_application(driver):
    ngo_page = NGODashboardPage(driver)
    ngo_page.go_to_applications()
    ngo_page.accept_first_application()
