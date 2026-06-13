return {
    "seblyng/roslyn.nvim",
    opts = {
        settings = {
            ["csharp|backgroundAnalysis"] = {
                -- Ensures background analysis runs for the entire solution, not just open documents
                analysisScope = "fullSolution",
                compilerDiagnosticsScope = "fullSolution",
            },
        },
    },
}
