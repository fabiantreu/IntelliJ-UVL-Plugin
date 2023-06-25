package com.example.exampleplugin;

import com.intellij.openapi.project.Project;
import com.intellij.openapi.wm.ToolWindow;
import com.intellij.openapi.wm.ToolWindowFactory;
import com.intellij.openapi.ui.Messages;

import javafx.application.Platform;
import javafx.embed.swing.JFXPanel;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.control.TextInputDialog;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.scene.layout.*;
import javafx.scene.shape.*;
import javafx.scene.input.*;
import javafx.event.*;

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

            StackPane root_feature = createFeature(300, 50, "Root");
            StackPane feature1 = createFeature(200, 200, "Feature 1");
            StackPane feature2 = createFeature(400, 200, "Feature 2");
            StackPane feature3 = createFeature(50, 350, "Feature 3");
            StackPane feature4 = createFeature(150, 350, "Feature 4");
            StackPane feature5 = createFeature(250, 350, "Feature 5");
            StackPane feature6 = createFeature(350, 400, "Feature 6");
            StackPane feature7 = createFeature(450, 400, "Feature 7");

            connectFeatures(root_feature, feature1);
            connectFeatures(root_feature, feature2);

            connectFeatures(feature1, feature3);
            connectFeatures(feature1, feature4);
            connectFeatures(feature1, feature5);

            connectFeatures(feature2, feature6);
            connectFeatures(feature2, feature7);

            fxPanel.setScene(scene);
        });

        toolWindow.getComponent().getParent().add(fxPanel);
    }

    public StackPane createFeature(int x, int y, String feature_name)
    {
        StackPane stack = new StackPane();

        Text text = new Text(feature_name);

        Rectangle feature = new Rectangle(80, 30);
        feature.setFill(Color.LIGHTGREY);
        feature.setStroke(Color.BLACK);

        stack.getChildren().addAll(feature, text);

        stack.setLayoutX(x);
        stack.setLayoutY(y);

        root.getChildren().add(stack);

        stack.setOnMouseDragged(event -> {
            if (event.getButton() == MouseButton.PRIMARY) {
                stack.setLayoutX(event.getSceneX());
                stack.setLayoutY(event.getSceneY());
            }
        });

        stack.setOnMouseClicked(event ->
        {
            if (event.getButton() == MouseButton.SECONDARY) {
                TextInputDialog dialog = new TextInputDialog();
                dialog.setTitle("Input Dialog");
                dialog.setHeaderText("Enter a value:");
                dialog.setContentText("Value:");

                dialog.showAndWait().ifPresent(value -> {
                    text.setText(value);
                });
            }
        });

        return stack;
    }

    public void connectFeatures(StackPane feature1, StackPane feature2)
    {
        Line line = new Line();

        line.startXProperty().bind(feature1.layoutXProperty().add(feature1.translateXProperty()).add(40));
        line.startYProperty().bind(feature1.layoutYProperty().add(feature1.translateYProperty()).add(30));
        line.endXProperty().bind(feature2.layoutXProperty().add(feature2.translateXProperty()).add(40));
        line.endYProperty().bind(feature2.layoutYProperty().add(feature2.translateYProperty()));

        root.getChildren().add(line);
    }
}
