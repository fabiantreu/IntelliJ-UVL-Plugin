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
import javafx.scene.layout.*;
import javafx.scene.shape.*;

import org.jetbrains.annotations.NotNull;

public class ToolWindowJavaFX implements ToolWindowFactory {

    Group root = new Group();
    @Override
    public void createToolWindowContent(@NotNull Project project, @NotNull ToolWindow toolWindow)
    {
        final JFXPanel fxPanel = new JFXPanel();

        Platform.setImplicitExit(false);
        Platform.runLater(() -> {

            Scene scene = new Scene(root, Color.WHITE);

            StackPane root_feature = createFeature(120, 50, "Root");
            StackPane feature1 = createFeature(50, 120, "Feature 1");
            StackPane feature2 = createFeature(190, 120, "Feature 2");

            connectFeatures(root_feature, feature1);
            connectFeatures(root_feature, feature2);

            fxPanel.setScene(scene);
        });

        toolWindow.getComponent().getParent().add(fxPanel);
    }

    public StackPane createFeature(int x, int y, String feature_name)
    {
        StackPane stack = new StackPane();

        Rectangle feature = new Rectangle(80, 30);
        feature.setFill(Color.WHITE);
        feature.setStroke(Color.BLACK);

        Text text = new Text(feature_name);

        stack.getChildren().addAll(feature, text);

        stack.setLayoutX(x);
        stack.setLayoutY(y);

        root.getChildren().add(stack);

        return stack;
    }

    public void connectFeatures(StackPane feature1, StackPane feature2)
    {
        Line line = new Line();
        line.setStartX(feature1.getLayoutX() + 40);
        line.setStartY(feature1.getLayoutY() + 30);
        line.setEndX(feature2.getLayoutX() + 40);
        line.setEndY(feature2.getLayoutY());

        root.getChildren().add(line);
    }
}
