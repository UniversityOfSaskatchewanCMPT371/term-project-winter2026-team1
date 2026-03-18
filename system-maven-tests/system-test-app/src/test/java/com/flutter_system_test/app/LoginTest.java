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
public class LoginTest {

    private WindowsDriver driver;
    private Process appProcess;

    @BeforeAll
    public void setup() throws Exception {

        // Working directory and application path
        String workingDir = "C:\\repo\\term-project-winter2026-team1\\frontend\\search_cms\\build\\windows\\x64\\runner\\Release";
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
                new URL("http://192.168.0.210:4723/"),
                appOptions
        );

        // Updated for Selenium 4
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
    }

    @Test
    public void testLoginFunctionality() {
        // Locate UI elements (UPDATED for Appium 9)
        Actions actions = new Actions(driver);
        actions.click().perform();
        // Use the wait driver to slow it down.
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));


        WebElement emailField = driver.findElement(AppiumBy.name("email_textbox"));

        actions.sendKeys("test_user_123");
        actions.perform();

        // Example: click login if needed
        // WebElement loginButton = driver.findElement(AppiumBy.name("Access System"));
        // loginButton.click();
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