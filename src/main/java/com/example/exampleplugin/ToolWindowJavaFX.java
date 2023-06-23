package com.example.exampleplugin;

import com.intellij.openapi.project.Project;
import com.intellij.openapi.wm.ToolWindow;
import com.intellij.openapi.wm.ToolWindowFactory;
import javafx.application.Platform;
import javafx.embed.swing.JFXPanel;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import org.jetbrains.annotations.NotNull;

public class ToolWindowJavaFX implements ToolWindowFactory {
    @Override
    public void createToolWindowContent(@NotNull Project project, @NotNull ToolWindow toolWindow)
    {
        final JFXPanel fxPanel = new JFXPanel();

        Platform.runLater(() -> {
            Group root = new Group();
            Scene scene = new Scene(root, Color.WHITE);
            Text text = new Text("Hello World");

            text.setX(50);
            text.setY(50);

            root.getChildren().add(text);

            fxPanel.setScene(scene);
        });

        toolWindow.getComponent().getParent().add(fxPanel);
    }
}
