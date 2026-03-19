package com.flutter_system_test.app;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.windows.WindowsDriver;
import io.appium.java_client.windows.options.WindowsOptions;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.junit.jupiter.api.*;

import java.io.File;
import java.net.URL;
import java.time.Duration;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)

// NOTE partial use of AI below
public class LoginTest {
    /**
     * 
     * This class is the initialization of file LoginTest
     * This functions off Junit and will fire off all
     * associated tests with the @Test underneath it's methods
     * 
     * It has both a @BeforeAll and @AfterAll
     * 
     * Pre-conditions:
     * (1) Appium is running on local machine
     * (2) NovaWindows is installed with appium
     * (3) Local ip 127.0.0.1 is availabe with port 4723
     * 
     *  
     */
    private WindowsDriver driver;
    private Process appProcess;

    @BeforeAll
    public void setup() throws Exception {

        /**
         * 
         * This is the setup function that initializes
         * the connection with appium
         * It has both a @BeforeAll and @AfterAll
         * 
         * Pre-conditions:
         * (1) Appium is running on local machine
         * (2) NovaWindows is installed with appium
         * (3) Local ip 127.0.0.1 is availabe with port 4723
         * (4) flutter's exe is built and exists in the release file
         * 
         *  
         */

        // Working directory and application path
        String workingDir = "C:\\471\\term-project-winter2026-team1\\frontend\\search_cms\\build\\windows\\x64\\runner\\Release";
        String appPath = workingDir + "\\flutter_supabase_template.exe";

        // Launch the application using ProcessBuilder
        ProcessBuilder builder = new ProcessBuilder(appPath);
        builder.directory(new File(workingDir));
        appProcess = builder.start();

        System.out.println("Waiting 5 seconds for app to launch...");
        Thread.sleep(5000);

        // Connect to Appium root session
        WindowsOptions rootOptions = new WindowsOptions();
        rootOptions.setApp("Root");
        rootOptions.setCapability("automationName", "NovaWindows");

        RemoteWebDriver rootDriver = new WindowsDriver(
                new URL("http://127.0.0.1:4723"),
                rootOptions
        );

        // Find the Flutter window 
        WebElement appWindow = rootDriver.findElement(AppiumBy.name("flutter_supabase_template"));

        String hwnd = appWindow.getAttribute("NativeWindowHandle");
        String hwndHex = "0x" + Integer.toHexString(Integer.parseInt(hwnd));

        rootDriver.quit();

        // Attach directly to the app by the windows hwnd hex[]
        WindowsOptions appOptions = new WindowsOptions();
        appOptions.setCapability("appTopLevelWindow", hwndHex);
        appOptions.setCapability("automationName", "NovaWindows");


        // Initialise the windows driver that the test will use
        driver = new WindowsDriver(
                new URL("http://127.0.0.1:4723/"),
                appOptions
        );

        // Updated for Selenium 4
    }

// END OF Partial AI Usage

    @Test
    public void testLoginFunctionality() throws InterruptedException {
        // Locate UI elements (UPDATED for Appium 9)
        Actions actions = new Actions(driver);
        actions.click().perform();
        // Use the wait driver to slow it down.
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));


        WebElement emailField = driver.findElement(AppiumBy.name("email_textbox"));
        // WebElement emailField = wait.until(ExpectedConditions.visibilityOfElementLocated(AppiumBy.name("email_textbox")));

        
        actions.moveToElement(emailField).click().perform();

        // Give Windows a tiny fraction of a second to register the UI focus shift
        Thread.sleep(200);

        actions.sendKeys("pleasework@fortheloveofgod.ca").perform();
        
        // WebElement loginButton = wait.until(ExpectedConditions.elementToBeClickable(AppiumBy.name("Access System")));
        // actions.moveToElement(loginButton).click().perform();


        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1000));

        // Example: click login if needed
        // WebElement loginButton = driver.findElement(AppiumBy.name("Access System"));
        // loginButton.click();


        // Testing Password
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));


        WebElement passwordField = driver.findElement(AppiumBy.name("password_textbox"));
        // WebElement emailField = wait.until(ExpectedConditions.visibilityOfElementLocated(AppiumBy.name("email_textbox")));

        
        actions.moveToElement(passwordField).click().perform();

        // Give Windows a tiny fraction of a second to register the UI focus shift
        Thread.sleep(200);

        actions.sendKeys("passwordypassword").perform();

        // Testing authorize access button
        WebElement authField = driver.findElement(AppiumBy.name("Access System"));
        actions.moveToElement(authField).click().perform();

        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(15));
        Thread.sleep(20000);


    }

    @AfterAll
    public void teardown() {
        if (driver != null) {
            driver.quit();
        }
        if (appProcess != null) {
            appProcess.destroy();
        }
    }
}