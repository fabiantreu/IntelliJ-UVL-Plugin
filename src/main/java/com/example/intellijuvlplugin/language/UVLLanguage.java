package com.example.intellijuvlplugin.language;

import com.intellij.lang.Language;

public class UVLLanguage extends Language {

    public static final UVLLanguage INSTANCE = new UVLLanguage();

    private UVLLanguage() {
        super("UVL");
    }

}