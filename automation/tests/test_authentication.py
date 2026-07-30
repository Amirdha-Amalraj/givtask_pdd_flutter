import pytest
from pages.landing_page import LandingPage
from pages.auth_page import AuthPage

def test_successful_login(driver):
    landing_page = LandingPage(driver)
    auth_page = AuthPage(driver)
    
    assert landing_page.is_logo_visible()
    landing_page.click_login()
    
    auth_page.login("ngo@test.com", "password123")
    # Verify navigation to dashboard
    # assert ... 

def test_invalid_login(driver):
    landing_page = LandingPage(driver)
    auth_page = AuthPage(driver)
    
    landing_page.click_login()
    auth_page.login("invalid@test.com", "wrong")
    
    error = auth_page.get_error_message()
    assert error == "Invalid credentials"
