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

public class FullSystemTest {
    /**
     * 
     * This class is the initialization of file FullSystemTest
     * This functions off JUnit and will fire off all
     * associated tests with the @Test underneath it's methods
     * 
     * It has both a @BeforeAll and @AfterAll
     * 
     * Preconditions:
     * (1) Appium is running on local machine
     * (2) NovaWindows is installed with Appium
     * (3) Local IP 127.0.0.1 is available with port 4723
     * 
     *  
     */
    private WindowsDriver driver;
    private Process appProcess;

    @BeforeAll
    public void setup() throws Exception {

        /**
         * This is the setup function that initializes
         * the connection with Appium
         * It has both a @BeforeAll and @AfterAll
         * 
         * Preconditions:
         * (1) Appium is running on local machine
         * (2) NovaWindows is installed with Appium
         * (3) Local IP 127.0.0.1 is availabe with port 4723
         * (4) Flutter's exe is built and exists in the release file
         */

        // Working directory and application path
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
        
        // Wait for the UI to show up so we don't wait for a refresh
        WebDriverWait appWait = new WebDriverWait(driver, Duration.ofSeconds(10));
        appWait.until(d -> driver.findElement(AppiumBy.name("email_textbox")));
        
        // Updated for Selenium 4
    }
    
    /**
     * Does an E2E test of the full system
     * 
     * Preconditions:
     * (1) setup() complete without errors
     * (2) Hardcoded credentials exist in backend as valid inputs
     * (3) Backend and Appium are running in background
     */
    @Test
    public void testFullSystemFunctionality() throws InterruptedException {
        Actions actions = new Actions(driver);
        actions.click().perform();

        // Use the wait driver to allow UI to fully render
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));

        /********************************************* Test 1: Login Page Test ******************************************************/

        // Find the UI element by name and click on it
        WebElement emailField = driver.findElement(AppiumBy.name("email_textbox"));
        actions.moveToElement(emailField).click().perform();

        // Give Windows a fraction of a second to register the UI focus shift
        Thread.sleep(200);

        // Type a correct email into the textbox
        actions.sendKeys("pleasework@fortheloveofgod.ca").perform();

        // Testing password field
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(1));

        // Find password text box and click on it
        WebElement passwordField = driver.findElement(AppiumBy.name("password_textbox"));
        actions.moveToElement(passwordField).click().perform();

        // Give Windows a tiny fraction of a second to register the UI focus shift
        Thread.sleep(200);

        // Type a correct password into the textbox
        actions.sendKeys("passwordypassword").perform();

        // Testing authorize access field 
        WebElement authField = driver.findElement(AppiumBy.name("Access System"));
        actions.moveToElement(authField).click().perform();

        // driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(60));

        // Wait for the UI to show up so we don't wait for a refresh
        WebDriverWait appWait = new WebDriverWait(driver, Duration.ofSeconds(60));

        /****************************************** Test 2: Homepage Loading Test ***************************************************/

        // Find an element on the homepage. If found, login is successful
        appWait.until(
            d -> driver.findElement(AppiumBy.name("Search..."))
        );

        System.out.println("Homepage loaded, login successful.");

        /****************************************** Test 3: Search Bar and Data Table Test ******************************************/

        // Find the search bar
        WebElement searchBar = driver.findElement(AppiumBy.name("Search..."));
        actions.moveToElement(searchBar).click().perform();

        // Give Windows a fraction of a second to register the UI focus shift
        Thread.sleep(200);

        // Type a correct data (e.g., Borden) into the search bar
        actions.sendKeys("DiRx-28").perform();

        // Click the search button 
        WebElement searchButton = driver.findElement(AppiumBy.name("Search"));
        actions.moveToElement(searchButton).click().perform();

        // Check if the search result is displayed. If found, search is successful
        appWait.until(
            d -> driver.findElement(AppiumBy.name("DiRx-28"))
        );

        System.out.println("Borden found, search successful.");

        // /****************************************** Test 4: Navigate to Add Data Page Test ******************************************/

        // Reset mouse position
        actions.moveByOffset(-2000, -2000).perform();

        // Manually move to click "Add" button
        actions.moveByOffset(100, 200).click().perform();

        // Check if Add page is loaded. If loaded, navigation successful
        appWait.until(
            d -> driver.findElement(AppiumBy.name("Add Data"))
        );

        System.out.println("Add data page loaded successfully.");

        // /****************************************** Test 5: Add Data Test ***********************************************************/

        // Find the site name field
        WebElement siteNameField = driver.findElement(AppiumBy.name("Enter Site Name (e.g., western end of slope)"));
        actions.moveToElement(siteNameField).click().perform();

        // Give Windows a fraction of a second to register the UI focus shift
        Thread.sleep(200);

        // Type the site name in the field
        actions.sendKeys("Appium Site").perform();

        // Find the Borden field
        WebElement bordenNameField = driver.findElement(AppiumBy.name("Enter Borden Number (e.g., DiRw-28)"));
        actions.moveToElement(bordenNameField).click().perform();

        // Give Windows a fraction of a second to register the UI focus shift
        Thread.sleep(200);

        // Type the Borden in the field
        actions.sendKeys("DiRx-00").perform();

        // Find the area name field
        WebElement areaNameField = driver.findElement(AppiumBy.name("Enter Area (e.g., western end of slope)"));
        actions.moveToElement(areaNameField).click().perform();

        // Give Windows a fraction of a second to register the UI focus shift
        Thread.sleep(200);

        // Type the area name in the field
        actions.sendKeys("Appium Area").perform();

        // Give Windows a fraction of a second to register the UI focus shift
        Thread.sleep(200);

        // Reset mouse position
        actions.moveByOffset(-2000, -2000).perform();

        // Manually move to click "Save" button
        actions.moveByOffset(300, 700).click().perform();

        System.out.println("Add data successful.");

        // /****************************************** Test 6: Homepage Update Test ****************************************************/

        // Reset mouse position
        actions.moveByOffset(-2000, -2000).perform();

        // Manually move to click "Home" button
        actions.moveByOffset(100, 150).click().perform();
        
        // Check to see if the newly added data exists in the homepage. If so, test completed 
        appWait.until(
            d -> driver.findElement(AppiumBy.name("Appium Site"))
        );

        System.out.println("System test completed!");
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




