package com.example.intellijuvlplugin.language;

import com.intellij.icons.AllIcons;
import com.intellij.openapi.fileTypes.LanguageFileType;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class UVLFileType extends LanguageFileType {

    public static final UVLFileType INSTANCE = new UVLFileType();

    private UVLFileType() {
        super(UVLLanguage.INSTANCE);
    }

    @NotNull
    @Override
    public String getName() {
        return "UVL file";
    }

    @NotNull
    @Override
    public String getDescription() {
        return "UVL language file";
    }

    @NotNull
    @Override
    public String getDefaultExtension() {
        return "uvl";
    }

    @Nullable
    @Override
    public Icon getIcon() {
        return AllIcons.FileTypes.Custom;
    }

}