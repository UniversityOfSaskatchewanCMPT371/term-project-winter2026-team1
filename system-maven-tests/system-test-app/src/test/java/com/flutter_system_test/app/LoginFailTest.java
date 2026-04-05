
package com.flutter_system_test.app;

import io.appium.java_client.AppiumBy;
import io.appium.java_client.windows.WindowsDriver;
import io.appium.java_client.windows.options.WindowsOptions;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.junit.jupiter.api.*;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;

import java.io.File;
import java.net.URL;
import java.time.Duration;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@Disabled
public class LoginFailTest {

    private WindowsDriver driver;
    private Process appProcess;
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
    @BeforeAll
    public void setup() throws Exception {

       /**
         * This is the setup function that initializes
         * the connection with appium
         * It has both a @BeforeAll and @AfterAll
         * 
         * Pre-conditions:
         * (1) Appium is running on local machine
         * (2) NovaWindows is installed with appium
         * (3) Local ip 127.0.0.1 is availabe with port 4723
         * (4) flutter's exe is built and exists in the release file
         */


        String currentDir = System.getProperty("user.dir");
        
        Path workingDirPath = Paths.get(currentDir, "..", "..", "frontend", "search_cms", "build", "windows", "x64", "runner", "Release").normalize();
        Path appExePath = workingDirPath.resolve("flutter_supabase_template.exe");

        // Print paths to the console so you can debug in CI/CD if it fails again
        System.out.println("Resolved Working Directory: " + workingDirPath.toAbsolutePath());
        System.out.println("Resolved App Path: " + appExePath.toAbsolutePath());

        // Launch the application using ProcessBuilder
        ProcessBuilder builder = new ProcessBuilder(appExePath.toString());
        builder.directory(workingDirPath.toFile());
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

        // Find the Flutter window (UPDATED for Appium 9)
        WebElement appWindow = rootDriver.findElement(AppiumBy.name("flutter_supabase_template"));

        String hwnd = appWindow.getAttribute("NativeWindowHandle");
        String hwndHex = "0x" + Integer.toHexString(Integer.parseInt(hwnd));

        rootDriver.quit();

        // Attach directly to the app by HWND
        WindowsOptions appOptions = new WindowsOptions();
        appOptions.setCapability("appTopLevelWindow", hwndHex);
        appOptions.setCapability("automationName", "NovaWindows");

        driver = new WindowsDriver(
                new URL("http://127.0.0.1:4723/"),
                appOptions
        );
        // Wait for the UI to show up so we don't wait for a refresh
        WebDriverWait appWait = new WebDriverWait(driver, Duration.ofSeconds(10));
        appWait.until(d -> driver.findElement(AppiumBy.name("email_textbox")));

        // Updated for Selenium 4
    }

    
    /**
     * Tests that a user can not log in with invalid email and password
     * 
     * pre conditions:
     * 1. setup() complete without errors
     * 2. hardcoded credentials exist in backend as valid inputs
     * 3. backend and Appium are running in background
     * 
     * Expected result:
     * Should see that the UI has produced an error message after entering invalid credentials
     * Will not log you into the application
     */
    @Test
    public void testLoginFunctionality() throws InterruptedException {
        Actions actions = new Actions(driver);
        actions.click().perform();
        // Use the wait driver to allow ui to fully render
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));

        // Find the ui element by name and click on it
        WebElement emailField = driver.findElement(AppiumBy.name("email_textbox"));
        actions.moveToElement(emailField).click().perform();

        // Give Windows a fraction of a second to register the UI focus shift
        Thread.sleep(200);
        // Type a incorrect email into the textbox
        actions.sendKeys("wrongEmail@wrongemail.ca").perform();


        // Testing Password Field
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));
        // Find Password text box and click on it
        WebElement passwordField = driver.findElement(AppiumBy.name("password_textbox"));
        actions.moveToElement(passwordField).click().perform();
        // Give Windows a tiny fraction of a second to register the UI focus shift
        Thread.sleep(200);
        // Type a incorrect password into the textbox
        actions.sendKeys("wrongpassword").perform();

        // Testing authorize access field 
        WebElement authField = driver.findElement(AppiumBy.name("Access System"));
        actions.moveToElement(authField).click().perform();
        // Should give an error message when trying to click on it with invalid credentials

        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(15));
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