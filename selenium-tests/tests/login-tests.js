const { Builder, By, until } = require('selenium-webdriver');

// Example E2E test for the Flutter Web Login Frontend
async function runLoginTests() {
    // Note: To run this test, you need ChromeDriver installed and your Flutter app running on web (e.g. localhost:8080)
    const APP_URL = 'http://localhost:8080/#/login'; 
    let driver = await new Builder().forBrowser('chrome').build();

    try {
        console.log('Navigating to', APP_URL);
        await driver.get(APP_URL);

        // Wait for Flutter web app to initialize and render elements
        // Flutter web uses a canvas, but if semantic labels are enabled, we can interact with them.
        // It's highly recommended to run Flutter web with: --dart-define=FLUTTER_WEB_USE_SKIA=false --web-renderer html
        // Or access text fields using generic input selectors if they render as standard inputs.

        // Wait for the email field (Assuming the semantic label or standard input is present)
        // Adjust these selectors based on your specific Flutter Web semantics rendering.
        console.log('Waiting for Email Input...');
        const emailInput = await driver.wait(
            until.elementLocated(By.css('input[type="email"], input[aria-label="Email"], flt-semantics[aria-label*="Email"]')), 
            10000
        );
        
        const passInput = await driver.findElement(By.css('input[type="password"], input[aria-label="Password"], flt-semantics[aria-label*="Password"]'));
        
        // Find the Login Button
        const loginButton = await driver.findElement(By.xpath('//flt-semantics[contains(@aria-label, "Login")] | //button[contains(text(), "Login")]'));

        console.log('Executing Test Case TC-001 (Valid Login)...');
        // Test Case TC-001: Valid Login
        await emailInput.sendKeys('admin@test.com');
        await passInput.sendKeys('ValidPass123!');
        await loginButton.click();

        // Wait for dashboard to load (checking URL change or dashboard element)
        await driver.wait(until.urlContains('dashboard'), 5000);
        console.log('✅ TC-001 Passed: Successfully logged in and redirected to dashboard.');

    } catch (error) {
        console.error('❌ Test Failed or Timed Out:', error.message);
    } finally {
        console.log('Closing browser...');
        await driver.quit();
    }
}

// Run the tests
runLoginTests();
