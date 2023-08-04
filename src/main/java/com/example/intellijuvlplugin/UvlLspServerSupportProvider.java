package com.example.intellijuvlplugin;

import com.intellij.execution.configurations.GeneralCommandLine;
import com.intellij.platform.lsp.api.LspServerSupportProvider;
import com.intellij.platform.lsp.api.ProjectWideLspServerDescriptor;

import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import org.jetbrains.annotations.NotNull;

public class UvlLspServerSupportProvider implements LspServerSupportProvider {
    @Override
    public void fileOpened(@NotNull Project project, @NotNull VirtualFile file, @NotNull LspServerStarter serverStarter) {
        if ("uvl".equals(file.getExtension())) {
            serverStarter.ensureServerStarted(new UvlLspServerDescriptor(project));
        }
    }
}

class UvlLspServerDescriptor extends ProjectWideLspServerDescriptor {
    public UvlLspServerDescriptor(Project project) {
        super(project, "UVL");
    }

    @Override
    public boolean isSupportedFile(VirtualFile file) {
        return "uvl".equals(file.getExtension());
    }

    @Override
    public GeneralCommandLine createCommandLine() {
        return new GeneralCommandLine("C:\\Users\\treuf\\Documents\\coding\\IntelliJ\\IntelliJ-UVL-Plugin\\src\\main\\resources\\uvls.exe", "--stdio");
        //TODO bundle with plugin - make path relative
    }
}
