return {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
        filewatching = "roslyn",
        settings = {
            ["csharp|backgroundAnalysis"] = {
                -- Ensures background analysis runs for the entire solution, not just open documents
                analysisScope = "fullSolution",
                compilerDiagnosticsScope = "fullSolution",
            },
        },
    },
}
