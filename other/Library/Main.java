package com.flipdots;

import FlipDot.FDDisplay;
import FlipDot.FDInstalledPanel;
import FlipDot.FlipDotUtil.FDDisplayBuilder;
import FlipDot.PanelTypes.FDType28;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/*
FlipDotJava library must be included in this project.
 */

public class Main {

    public static void main(String[] args) {
        if(args.length < 1) {
            System.out.println("Specify path to image file to be displayed");
            return;
        }
        FDDisplay display;

            /*
            Use FDDisplayBuilder class to quickly create display of regular shape and regular addressing pattern.
            This display has panels with address as follows:

            0   |   1   |   2   |   3
            4   |   5   |   6   |   7
            8   |   9   |   10  |   11
            12  |   13  |   14  |   15

            If you are using other panel type than 28x7 use it. Implemented types are:
            FDType14, FDType7, FDType10x14.

            Default orientation (rotation) of a panel is one with arrow heading upwards. Arrow can be found on the back of a panel.
            This orientation is defined by enum FDInstalledPanel.Orientation.arrow_up.

            Address is ip address of a converted connected to panel.

            Port is a port of specific output of a converter. For WizNet devices 5000 is default value for the first output.

            You can choose either TCP or UDP protocol for communication. TCP is preferred.
             */
        display = FDDisplayBuilder.buildDisplay(
                4,
                4,
                new FDType28(),                         // Model of a panel. Other available: FDType14, FDType7, FDType10x14
                FDInstalledPanel.Orientation.arrow_up,  // rotation of a panel. Arrow is on the back side of a panel.
                "192.168.0.100",                // converter IP address
                5000,                              // port of a output of converter.
                FDDisplayBuilder.protocol.TCP           // communication protocol. TCP or UDP. TCP is preferred.
        );

        try {
            display.connectSockets();                       // Communication channels are not opened. This line opens sockets.

            File file = new File(args[0]);                  // File is opened from the first program argument
            BufferedImage image;
            image = ImageIO.read(file);                     // Image is created from file
            /*
            Image is iterated over its pixels. For each pixel brightness is computed. If brightness is above threshold
            then corresponding pixel in display is colored light color.
            No scaling is applied. On pixel of an image is one dot of a display.
             */
            display.convertBitmapToBits(image, 0.5f);  // Now pixels are stored in display object.
            display.prepareScreen();                            // Data is sent to panels, but panels are not yet refreshed (flipped)
            display.refreshDisplay();                           // All panels are refreshed (flipped) at once.
            display.closeSockets();                             // sockets must be closed at the end. Otherwise converter might crash.
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
