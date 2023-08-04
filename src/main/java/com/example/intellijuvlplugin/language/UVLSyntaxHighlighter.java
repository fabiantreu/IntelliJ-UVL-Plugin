package com.example.intellijuvlplugin.language;

import com.example.intellijuvlplugin.language.parser.UVLLexer;
import com.intellij.lexer.Lexer;
import com.intellij.openapi.editor.DefaultLanguageHighlighterColors;
import com.intellij.openapi.editor.colors.TextAttributesKey;
import com.intellij.openapi.fileTypes.SyntaxHighlighterBase;
import com.intellij.psi.tree.IElementType;
import org.antlr.intellij.adaptor.lexer.ANTLRLexerAdaptor;
import org.jetbrains.annotations.NotNull;

import static com.intellij.openapi.editor.colors.TextAttributesKey.createTextAttributesKey;
public class UVLSyntaxHighlighter extends SyntaxHighlighterBase {
    private static final TextAttributesKey[] EMPTY_KEYS = new TextAttributesKey[0];
    public static final TextAttributesKey COMMENT =
            createTextAttributesKey("UVL_COMMENT", DefaultLanguageHighlighterColors.LINE_COMMENT);

    @NotNull
    @Override
    public Lexer getHighlightingLexer() {
        UVLLexer lexer = new UVLLexer(null);
        return new ANTLRLexerAdaptor(UVLLanguage.INSTANCE, lexer);
    }

    @Override
    public TextAttributesKey @NotNull [] getTokenHighlights(IElementType tokenType) {
        return new TextAttributesKey[] {COMMENT};

//        if ( !(tokenType instanceof TokenIElementType) ) return EMPTY_KEYS;
//        TokenIElementType myType = (TokenIElementType) tokenType;
//        int ttype = myType.getANTLRTokenType();
//
//        TextAttributesKey attrKey;
//        switch(ttype) {
//            case UVLLexer.OPEN_COMMENT:
//                attrKey = COMMENT;
//                break;
//            default:
//                return EMPTY_KEYS;
//        }
//
//        return new TextAttributesKey[] {attrKey};
    }
}
