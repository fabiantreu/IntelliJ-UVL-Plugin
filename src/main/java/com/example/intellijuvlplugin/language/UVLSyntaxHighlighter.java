package com.example.intellijuvlplugin.language;

import com.example.intellijuvlplugin.language.parser.UVLLexer;
import com.example.intellijuvlplugin.language.parser.UVLParser;
import com.intellij.lexer.Lexer;
import com.intellij.openapi.editor.DefaultLanguageHighlighterColors;
import com.intellij.openapi.editor.colors.TextAttributesKey;
import com.intellij.openapi.fileTypes.SyntaxHighlighterBase;
import com.intellij.psi.tree.IElementType;
import org.antlr.intellij.adaptor.lexer.ANTLRLexerAdaptor;
import org.antlr.intellij.adaptor.lexer.PSIElementTypeFactory;
import org.antlr.intellij.adaptor.lexer.TokenIElementType;
import org.jetbrains.annotations.NotNull;

import static com.intellij.openapi.editor.colors.TextAttributesKey.createTextAttributesKey;
public class UVLSyntaxHighlighter extends SyntaxHighlighterBase {
    private static final TextAttributesKey[] EMPTY_KEYS = new TextAttributesKey[0];
    public static final TextAttributesKey STRING =
            createTextAttributesKey("UVL_STRING", DefaultLanguageHighlighterColors.STRING);

    public static final TextAttributesKey COMMENT =
            createTextAttributesKey("UVL_COMMENT", DefaultLanguageHighlighterColors.LINE_COMMENT);

    static {
        PSIElementTypeFactory.defineLanguageIElementTypes(UVLLanguage.INSTANCE,
                UVLParser.tokenNames,
                UVLParser.ruleNames);
    }

    @NotNull
    @Override
    public Lexer getHighlightingLexer() {
        UVLLexer lexer = new UVLLexer(null);
        return new ANTLRLexerAdaptor(UVLLanguage.INSTANCE, lexer);
    }

    @NotNull
    @Override
    public TextAttributesKey[] getTokenHighlights(IElementType tokenType) {
        if ( !(tokenType instanceof TokenIElementType) ) return EMPTY_KEYS;
        TokenIElementType myType = (TokenIElementType)tokenType;
        int ttype = myType.getANTLRTokenType();
        TextAttributesKey attrKey;
        switch ( ttype ) {
//            case UVLLexer.STRING:
//                attrKey = STRING;
//                break;
            case UVLLexer.COMMENT:
                attrKey = COMMENT;
                break;
            default :
                return EMPTY_KEYS;
        }
        return new TextAttributesKey[] {attrKey};
    }
}